displacement wooddisplace(float Km = 0.001;)
{
	float hump = 0;
	normal n = normalize(N);
	
	//displacement wood texture using displacement texture
	//generated by GIMP

	color c = texture("wood2Disp.tex", (s*2)-0.5, (t*2)-0.5);
	hump = (comp(c, 0) + comp(c, 1) + comp(c, 2));
	P = P - n * hump * Km;
	N = calculatenormal(P);
}
