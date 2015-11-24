displacement texdisplace(float Ktex = 0.0008;
						float Km = 0.003;)
{
	//displacement shader for noise and texture

	//http://www.fundza.com/rman_shaders/displacement/index.html

	point Pn = transform("object", P);
	float noiseVal = 0;
	float hump = 0;
	normal n = normalize(N);
	float ss = Pn[0] + 1.35;
	float tt = Pn[1] + 1.25;
	
	//creating the noise value
	noiseVal = noise(s*2000, t*2000);

	//texture information
	color c = color texture("olddude.tex", ss/2.8, tt/2.5);

	hump = (comp(c, 0) + comp(c, 1) + comp(c, 2));
	P = P - (n *hump*Ktex) - (n*noiseVal/6*Km);
	N = calculatenormal(P);
}
