surface wood(float Ka = 1.2;
		float Kd = .04;
		float Ks = 0.55;
		float roughness = .1;
		color specularcolor = 1;)
{
	normal Nf = faceforward (normalize(N),I);
 	vector V = -normalize(I);
	
	//getting texture information
	color Ct = color texture("wood2.tex", (s*2)-0.5, (t*2)-0.5);

	float occ = occlusion(P, Nf, 128, "maxdist", 100000, "bias", 0.005);

	//environment map settings
	float Kr = 0.1;
	vector Rcurrent = reflect(I,Nf);
	vector Rworld = vtransform("world", Rcurrent);
	color Cb = color environment("enviro.tex", Rworld);
	color Cr = trace(P, Rcurrent);

	Oi = Os;
    Ci = Oi * ( (1-occ) * Ct * (Ka*ambient() + Kd*diffuse(Nf) + specularcolor * Ks * (Cb * Kr + Cr * Kr + specular(Nf, V, roughness))));
}
