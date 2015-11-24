surface aniso(float Ka = 0.05, Kd = 0.04, Ks = .5, Kr = 1;
               float uroughness = 0.33, vroughness = 0.6;)
{
	//anisotropic BRDF model
	//using the same BRDF model on 2 shaders because of the textured and non-textured part
	
	normal Nf = faceforward (normalize(N), I);
	vector V = -normalize(I);
	
	vector xdir = normalize(dPdu);
	
	float sqr (float x) { return x*x; }

    float cos_theta_r = clamp (Nf.V, 0.0001, 1);
    vector X = xdir / uroughness;
    vector Y = (Nf ^ xdir) / vroughness;

    color C = 0;
    
    illuminance (P, Nf, PI/2) {
	float nonspec = 0;
	lightsource ("__nonspecular", nonspec);
	if (nonspec < 1) {
	    vector LN = normalize (L);
	    float cos_theta_i = LN . Nf;
	    if (cos_theta_i > 0.0) {
		vector H = normalize (V + LN);
		float rho = exp (-2 * (sqr(X.H) + sqr(Y.H)) / (1 + H.Nf))
		    / sqrt (cos_theta_i * cos_theta_r);
		C += Cl * ((1-nonspec) * cos_theta_i * rho);
	    }
	}
    }

	color spec = C / (5 * uroughness * vroughness);

	//mapping the texture to the disk
	point Pn = transform("object", P);

	float ss = Pn[0] + 1.35;
	float tt = Pn[1] + 1.25;

	color Ct = ( 0.097, 0.32, 0.256 );

	//greased dirty look
	float repeatCount = 1.3;
	float low = 0.5;
	float amp = 3.5;
	float high = 0.7;
	float noise = noise((ss-1.35)*repeatCount, (tt-1.25)*repeatCount);
	float blend = smoothstep(low, high, noise);

	float noise2 = noise((ss/3)*0.3, (tt/3)*0.3);
	float blend2 = smoothstep(low, high, noise2);

	float off = tt + ((blend+noise2)*amp);

	color Cx = mix(color(0.025,0.025,0.025), color(0,0,0), off);
	Ct += Cx;
	Ct = mix(color (1,1,1),Ct, 1);

	//environment map settings
	vector Rcurrent = reflect(I,Nf);
	vector Rworld = vtransform("world", Rcurrent);
	color Cb = color environment("enviro.tex", Rworld);
	color Cr = trace(P, Rcurrent);
	
	//ambient occlusion
	float occ = occlusion(P, Nf, 128, "bias", 0.55);
	
	Ci = (1-occ) * Ct * (Ka*ambient() + Kd*diffuse(Nf) + Ks*(spec+Cr*Kr+Cb*Kr));	

	Oi = Os;
	Ci *= Oi;
}
