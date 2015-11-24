displacement noisedisp(float Km = 0.005;)
{
	//natural variaton to the object using noise and displacement
	float hump = 0;
	normal n = normalize(N);

	hump = noise(s*2000, t*2000);
	P = P - n *hump/4*Km;
	N = calculatenormal(P);
}
