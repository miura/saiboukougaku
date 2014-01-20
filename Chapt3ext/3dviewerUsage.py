from ij3d import Image3DUniverse, Content

# showing fly brain using 3Dviewer

flyurl = "http://imagej.nih.gov/ij/images/flybrain.zip"
imp = IJ.openImage(flyurl)
univ = Image3DUniverse()
univ.show()
c = univ.addVoltex(imp)
#Thread.sleep(2000)
#univ.removeContent(c.getName())
#Thread.sleep(2000)
#c.displayAs(Content.ORTHO)
#c = univ.addMesh(imp)