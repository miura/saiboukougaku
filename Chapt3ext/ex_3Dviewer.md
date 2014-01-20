
#スクリプトによる3Dviewerの使用

3DViewerはマウスを使ってぐりぐりと動かしながら扱うことがほとんどの場合だろう。とはいえ、スクリプトからも比較的容易にアクセスすることが可能であり、特に複雑な３次元画像のムービーを作るときにはスクリプトを書くことでその動きを細かく制御することができる。このページでは、Jythonを使って3DViewerを使う方法を紹介する。

Jythonの書き方がわからない、という方は以下のページで学んでほしい。

[Jythonの書き方・使い方](https://sites.google.com/site/imagejjp/articles/jython-basics)

##3Dviewerへのプロット

以下のコードを実行すれば、サンプル画像[Fly brain]が3Dviewerにプロットされる。まずは試してみて欲しい。

    from ij3d import Image3DUniverse
    
    flyurl = "http://imagej.nih.gov/ij/images/flybrain.zip"
    imp = IJ.openImage(flyurl)
    univ = Image3DUniverse()
    univ.show()
    c = univ.addVoltex(imp)
    
コードを解説しよう。

- １行目：3DviewerのGUIのクラスをインポートしておく。なお、3DviewerのJavadocは[こちらにある](http://132.187.25.13/ij3d/download/docs/index.html)。
- ３行目：ImageJのウェブサイトにあるサンプル画像Fly brainのURLを変数として設定する。
- ４行目：上記の画像を、ImagePlusオブジェクトとして取得する。
- ５行目：Image3DUniverseをインスタンス化する。
- ６行目：このインスタンスをデスクトップ上に表示する。
- ７行目：flybrainのImagePlusオブジェクトを、3Dviewer上にプロットする。


##3Dviewerのオブジェクトを動かす

さて、この3DViewerに描画された三次元オブジェクトを動かしてみよう。下のコードを上のコードに続けて貼り付けて実行すると、オブジェクトがぐるぐるとまわる。

	from ij3d.behaviors import ViewPlatformTransformer
	from javax.media.j3d import Transform3D
	from javax.vecmath import Vector3d
	import time
	
	vtf = ViewPlatformTransformer(univ, univ)
	x1z1 = Vector3d(1, 0, 1)
	univ.rotateToPositiveXY()
	for zm in range(1,3000, 10):
	    vtf.zoomTo(zm)
	    vtf.rotate(x1z1, 0.03)
	    time.sleep(0.01)
	 
	for zm in range(3000, 1000, -10):
	    vtf.zoomTo(zm)
	    vtf.rotate(x1z1, 0.03)
	    time.sleep(0.01)


コードを解説する。

- 最初の4行はインポート文で、必要なクラスをここで宣言する。
- 6行目：　ViewPlatformTransformerをインスタンス化（オブジェクトを生成）する。引数はふたつあるが、両方共に現在表示しているImage3DUniverseのインスタンスを指定する。
- 7行目：　回転の方向を指定する3次元ベクトルをVector3dクラスをインスタンス化して生成する。引数は三次元の座標になる。ここではx=1, y = 0, z = 1のベクトルを指定した。これはx軸を中心とする回転と、z軸を中心とする回転の組み合わせになる。x軸、y軸はモニターの平面を構成する座標軸であり、z軸は画面に垂直な方向に伸びる軸である、と想像するとわかりやい。z軸を中心にまわる、ということはすなわち、描画した構造が時計の針のようにくるくるとまわる、という印象になる。上のコードが動くことが確認できたら、このベクトルを(1, 0, 0)にしたり(0, 0, 1)にしたりすると、どのような動きをどの項が実現するのかがわかるだろう。
- 8行目：　Image3DUniverseのメソッドを使って、デフォルトの位置にオブジェクトの配置を戻す。今回はスクラッチから描画するスクリプトなのであまり意味はないが、手で動かしてから実行する場合には開始のポジションを固定したほうがよいので、この一行をいれる。
- 9行目：　回転とズームの動きを構成するためのループの開始。pythonの標準関数rangeを使って1から3000まで10づつ大きくなっていくようなリストを作成し、このリストをループすることになる。変数はzmに順番に使われていく。
- 10行目：　ViewPlatformTransformerのインスタンスに対して、ズームの倍率を指定する…　この場合にはzmで指定をしているので、ループにともなってすこしずつ大きくなっていく、といってもレンズの倍率とはことなり、観察者の視点からの距離を指定する。0は観察者の目にぴったりくっついていることになるが、1になると少し離れる。今回は3000が最大値であり、今回の動きでは一番の遠点にオブジェクトを位置させることになる。オブジェクトは徐々に離れていくような印象になる。
- 11行目：　ViewPlatformTransformerのインスタンスに対して、回転を指定する。第一引数がループの前に作成した3次元ベクトルのオブジェクト、第二引数が回転する角度（ラジアン）。
- 12行目：　関数timeをつかってスクリプトの進行を0.01msec止める。これがないとあっというまに動きが終わってしまう。
- 13行目からは、逆方向のループ。内容は同じである。

##3Dviewerのオブジェクトを動きを動画にする

以上で3DViewer上でオブジェクトを動かすスクリプトの書き方はわかったと思うのだが、これをムービーにして保存するには要所要所でスナップショットを撮影し、スタックに保存することが必要になる。以下のような感じである。

	imp = univ.takeSnapshot()
	stk = ImageStack(imp.width, imp.height)
	stk.addSlice(imp.getProcessor())

Image3DUniverseのメソッドのひとつにtakeSnapshot()がある。返り値がImagePlusオブジェクトであり、これをこのままスタックに保持していけば良い。二行目で空のスタックオブジェクトを用意し、三行目でスナップショットのImageProcessorインスタンスを加えている。実際のスクリプトでは、ループ毎に一枚ずつ撮影し、スタックにキープする、という形になる。以下はここまでのすべてを組み合わせたスクリプトである。

<p><img src="https://www.google.com/chart?chc=sites&amp;cht=d&amp;chdp=sites&amp;chl=%5B%5BGoogle+Gadget'%3D20'f%5Cv'a%5C%3D0'10'%3D499'0'dim'%5Cbox1'b%5CF6F6F6'fC%5CF6F6F6'eC%5C0'sk'%5C%5B%22Derquinse+Gist.GitHub+Gadget%22'%5D'a%5CV%5C%3D12'f%5C%5DV%5Cta%5C%3D10'%3D0'%3D500'%3D747'dim'%5C%3D10'%3D10'%3D500'%3D747'vdim'%5Cbox1'b%5Cva%5CF6F6F6'fC%5CC8C8C8'eC%5C'a%5C%5Do%5CLauto'f%5C&amp;sig=1FAwVqvKcXYfbnWInkrzwVU8h7M" data-igsrc="http://220.gmodules.com/ig/ifr?mid=220&amp;synd=trogedit&amp;url=http%3A%2F%2Fgoo.gl%2FGGBZS&amp;up_gistId=8520754&amp;h=750&amp;w=100%25" data-type="ggs-gadget" data-props="align:left;borderTitle:Derquinse Gist.GitHub Gadget;height:750;igsrc:http#58//220.gmodules.com/ig/ifr?mid=220&amp;synd=trogedit&amp;url=http%3A%2F%2Fgoo.gl%2FGGBZS&amp;up_gistId=8520754&amp;h=750&amp;w=100%25;mid:220;scrolling:no;showBorder:true;showBorderTitle:true;spec:http#58//goo.gl/GGBZS;up_gistId:8520754;width:100%;" width="500" height="750" style="display:block;text-align:left;margin-right:auto;" class="igm"><br>
</p>

<https://gist.github.com/cmci/8520754>

出力されるスタックをmpeg4圧縮のムービーに変換したものが以下の動画である 。スタックを [File > SaveAs > Avi...]でエクスポートし（ファイル名はてきとうにout-2.aviとした）、ffmepeg を使って次のようなコマンドで変換した。

	ffmpeg -i out-2.avi -vcodec mpeg4 -qscale 0 out-2.mov

<br>
<div><img src="https://www.google.com/chart?chc=sites&amp;cht=d&amp;chdp=sites&amp;chl=%5B%5BEmbedding_Title_Docs_Video'%3D20'f%5Cv'a%5C%3D0'10'%3D499'0'dim'%5Cbox1'b%5CF6F6F6'fC%5CF6F6F6'eC%5C0'sk'%5C%5B%22out-2mov%22'%5D'a%5CV%5C%3D12'f%5C%5DV%5Cta%5C%3D10'%3D0'%3D500'%3D297'dim'%5C%3D10'%3D10'%3D500'%3D297'vdim'%5Cbox1'b%5Cva%5CF6F6F6'fC%5CC8C8C8'eC%5C'a%5C%5Do%5CLauto'f%5C&amp;sig=oXax3pnrQETiCzrGVpzHn9gXefA" data-props="align:left;showBorder:true;showBorderTitle:true;borderTitle:out-2.mov;height:265;width:425" id="3047056389041245" data-type="docs-video" class="sites-placeholder-docs-video" data-origsrc="0BwuMkLroHHDDdlBwQ1RVYnhSQms" style="display: block; text-align: left;" width="500" height="300"></div>
<br>




