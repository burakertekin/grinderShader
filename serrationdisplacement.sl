displacement serration(
	float dispScale=0.0025;
	float RepeatS=160;
	float RepeatT=1; 
	float trueDisp=1;)
{
	// make a copy of the normal
	normal NN = normalize(N);
	point PP;

	// now calculate the new disp value for P
	float ss=mod(s*RepeatS,1);
	float tt=mod(t*RepeatT,1);

	float disp=sin(ss*PI*2)*sin(tt*PI*2);
	//smoothing the transition
	float smooth = smoothstep(0.01, 0.2, t) * (1 - smoothstep(0.87, 1, t));

	PP=(P)-((NN-1.5)*disp*dispScale*smooth);
	N=calculatenormal(PP);
	if(trueDisp == 1)
		P=PP;
}
