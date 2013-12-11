t1 = getTime();
ww = getWidth();
hh = getHeight();
ch1A = newArray(ww * hh);
ch2A = newArray(ww * hh);
for (ypos = 0; ypos < hh; ypos++){
	for (xpos = 0; xpos < ww; xpos++){
		setSlice(1);
		c1pix = getPixel(xpos, ypos);
		ch1A[ypos * ww + xpos] = c1pix;
		setSlice(2);
		c2pix = getPixel(xpos, ypos);
		ch2A[ypos * ww + xpos] = c2pix;
	}
}
t2 = getTime();
Array.getStatistics(ch1A, min1, max1, mean1, stdDev1);
Array.getStatistics(ch2A, min2, max2, mean2, stdDev2);
Plot.create("Colocalization", "Lysozome", "Microtubule");
Plot.setLimits(min1, max1*1.1, min2, max2*1.1);
Plot.add("dots", ch1A, ch2A);
//print("width", ww, " array length", ch1A.length);
print("Processing Time", t2-t1, "[msec]");