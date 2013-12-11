t1 = getTime();
ww = getWidth();
hh = getHeight();
for (ypos = 0; ypos < hh; ypos++){
	makeLine(0, ypos, ww-1, ypos);
	setSlice(1);
	pa = getProfile();
	if (ypos == 0)
		ch1A = pa;
	else 
		ch1A = Array.concat(ch1A, pa);
	setSlice(2);
	pa = getProfile();
	if (ypos == 0)
		ch2A = pa;
	else 
		ch2A = Array.concat(ch2A, pa);
				
}
t2 = getTime();
Array.getStatistics(ch1A, min1, max1, mean1, stdDev1);
Array.getStatistics(ch2A, min2, max2, mean2, stdDev2);
Plot.create("Colocalization", "Lysozome", "Microtubule");
Plot.setLimits(min1, max1*1.1, min2, max2*1.1);
Plot.add("dots", ch1A, ch2A);
print("Processing Time", t2-t1, "[msec]");