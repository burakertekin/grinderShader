surface plastic (
		float Ka = 0.6;
		float Kd = .1;
		float Ks = 0.01;
		float roughness = .1;
		color specularcolor = 1;)
{
    normal Nf = faceforward (normalize(N),I);
    vector V = -normalize(I);

	float val = float texture("plastictex.tex");
	
	float repeatCount = 1000;
	color Ca = float noise(s*repeatCount, t*repeatCount);
	color Ct = Cs;
	Ct = mix(color(0.95,0.95,0.95), Ct, val); 
	Ct += Ca/10;

	//environment map settings
	float Kr = 0.7;
	vector Rcurrent = reflect(I,Nf);
	vector Rworld = vtransform("world", Rcurrent);
	color Cb = color environment("enviro.tex", Rworld);
	color Cr = trace(P, Rcurrent);

	float occ = occlusion(P, Nf, 128, "bias", 0.01, "maxvariation", 0.02);
	
    Oi = Os;
    Ci = Oi * ( (1-occ) * Ct * (Ka*ambient() + Kd*diffuse(Nf)) +
		specularcolor * Ks*(specular(Nf,V,roughness)+Cr*Kr+Cb*Kr));
}

