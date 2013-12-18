# 共局在プロットの高速化

連載第三回で共局在プロットのImageJマクロを示した。

<p><img src="https://www.google.com/chart?chc=sites&amp;cht=d&amp;chdp=sites&amp;chl=%5B%5BGoogle+Gadget'%3D20'f%5Cv'a%5C%3D0'10'%3D499'0'dim'%5Cbox1'b%5CF6F6F6'fC%5CF6F6F6'eC%5C0'sk'%5C%5B%22Derquinse+Gist.GitHub+Gadget%22'%5D'a%5CV%5C%3D12'f%5C%5DV%5Cta%5C%3D10'%3D0'%3D500'%3D397'dim'%5C%3D10'%3D10'%3D500'%3D397'vdim'%5Cbox1'b%5Cva%5CF6F6F6'fC%5CC8C8C8'eC%5C'a%5C%5Do%5CLauto'f%5C&amp;sig=Jm_TFNyZRtdXs2NVW6lwt3nZFZg" data-igsrc="http://74.gmodules.com/ig/ifr?mid=74&amp;synd=trogedit&amp;url=http%3A%2F%2Fgadgets.derquinse-commons.googlecode.com%2Fgit%2Fgist-github%2Fgist-github-gadget.xml&amp;up_gistId=7547786&amp;h=400&amp;w=100%25" data-type="ggs-gadget" data-props="align:left;borderTitle:Derquinse Gist.GitHub Gadget;height:400;igsrc:http#58//74.gmodules.com/ig/ifr?mid=74&amp;synd=trogedit&amp;url=http%3A%2F%2Fgadgets.derquinse-commons.googlecode.com%2Fgit%2Fgist-github%2Fgist-github-gadget.xml&amp;up_gistId=7547786&amp;h=400&amp;w=100%25;mid:74;scrolling:auto;showBorder:true;showBorderTitle:true;spec:http#58//gadgets.derquinse-commons.googlecode.com/git/gist-github/gist-github-gadget.xml;up_gistId:7547786;width:100%;" width="500" height="400" style="display:block;text-align:left;margin-right:auto;" class="igm"><br>
</p>

<https://gist.github.com/cmci/7547786>

このマクロは、少々手直しすることで高速化が可能である。以下、その解説をするつもりであるが、その前に連載で誌面の都合上、マクロの解説を短くにしたので、特にプロットの部分についてまず解説を加える。まず後半の

    Array.getStatistics(ch1A, min1, max1, mean1, stdDev1); 
    Array.getStatistics(ch2A, min2, max2, mean2, stdDev2);

についてであるが、Array.getStatisticsは、配列用の統計値を算出するためのマクロ関数である。この関数に特徴的なのが、統計値が引数として与えられた変数に返り値となって格納される、という点にある。通常のプログラミング言語では、右辺に対して左辺に返り値が与えられるが、Array.getStatisticsでは少々特殊なことになっているのである。引数として与える変数は初期化の必要がなく、いきなり指定することができる。第二引数から、最小値、最大値、平均、標準偏差が統計値である。

今回の例では、min1, max1, mean1, stdDev1をチャネル１のピクセル値の配列ch1Aの統計値の変数群として、min2, max2, mean2, stdDev2をチャネル２のピクセル値の配列ch2Aの統計値の変数群として与えた。これらのラインが実行されたあとには、これらの変数には統計値が格納されていることになる。

なぜこれらの統計値を取得するかというと、つづく図のプロットでXY軸それぞれのレンジを設定したいからである。プロットは次の一行で始まる。

    Plot.create("Colocalization", "Lysozome", "Microtubule");

この行により、プロットするための紙が用意されると考えると良い。第一引数はプロットのタイトル、第二引数はX軸のラベル、第三引数はY軸のラベルである。その次の行、

	Plot.setLimits(min1, max1*1.1, min2, max2*1.1);

の第一、第二引数がX軸のレンジ、第三、第四引数がY軸のレンジとなる。最小値はそれぞれの配列の最小値、最大値はそれぞれの配列に10％のマージンを与えた値を指定した(最大値に1.1をかけている)。マージンはなくてもよいのだが、見やすさのためにそうした。

最後のラインは

	Plot.add("dots", ch1A, ch2A);
	
である。第一引数にはプロットの形状を指定する。ここでは点（"dots"）とした。他にも線"line"、 丸　"circles"、四角 "boxes"、 三角　"triangles"、 プラス"crosses"、バツ "x"、 誤差バー　"error bars"などが指定可能である。なお、今回は散布図なので折れ線でつなぐと大変なことになる。

第二引数はXの値の配列、第三引数はそれに対応するYの値の配列を指定する。

このあとに、

	Plot.show()
	
を加えると、プロットを表示せよ、というコマンドになるのだが、今回の場合は省略してよい。マクロの実行が終わると、デフォルトでPlot.show()が自動的に実行されるからである。他の計算があとに続く場合、その前にプロットを表示したいときにはPlot.show()が必要となる。プロットのフォント種、フォントサイズ、フォントの色やプロットの色、その他もろもろの設定も可能であるが、今回はこうしたこまかい設定は行っていない。美しいプロットを行いたい方は、ぜひとも各自挑戦して欲しい。プロットに関連する関数は"Plot."から始まる関数群である。以下にリンクする。

<http://rsbweb.nih.gov/ij/developer/macro/functions.html#Plot>

私が作成したマクロで少々手の込んだプロットを行っている例は以下にある。参考になるかもしれないのでリンクする。

<http://cmci.embl.de/downloads/spindlefanalyzer>

![spindlefanalyzer](http://cmci.embl.de/dls/SpindleIntensity/Intensity_profile.jpg "spindlefanalyzer")


##ループの削減による高速化

さて、共局在プロットの高速化について。時間がかかっている部分がどこであるかを考えると、次の二点である。

1. ループが全ピクセル数の数だけ回る。
2. ループ毎に表示されているチャネルをsetSliceで切り替えている。

という2つの点にある。まずループの回数を考えてみよう。ループ毎にチャネルの表示を切り替えているので、減らすにはどうしたらよいだろうか。次のサンプル画像の場合で考えてみる

![hela-cells_part](https://raw.github.com/cmci/saiboukougaku/master/Chapt3ext/imgs/hela-cells_part.png)

[ダウンロードリンク](https://github.com/cmci/saiboukougaku/blob/master/Chapt3/imgs/hela-cells_part.tif?raw=true)

この画像は連載を書くために用意した画像で、サンプル画像[hela-cells]を切り抜いたものである。幅76ピクセル、高さ80ピクセルの画像であり、マクロで示したように各ピクセルをループした場合には、6240回のループが実行される。しかも毎回setSlice関数によって、チャネルを切り替えが2回起きるので、15480回切り替えが実行されることになる。

そこで、ループの回数を大幅に下げることを考え、行ごとのピクセル値を配列で取得することを試みよう。各行に水平なlineRoiをセットし、その領域のピクセル値を配列として一気に取得する。この取得した配列を、次々に連結(concatenate)すれば、画像をひとつだけの配列として取得することが可能である。このように改変したものが下記のスクリプトである。

<p><img src="https://www.google.com/chart?chc=sites&amp;cht=d&amp;chdp=sites&amp;chl=%5B%5BGoogle+Gadget'%3D20'f%5Cv'a%5C%3D0'10'%3D499'0'dim'%5Cbox1'b%5CF6F6F6'fC%5CF6F6F6'eC%5C0'sk'%5C%5B%22Derquinse+Gist.GitHub+Gadget%22'%5D'a%5CV%5C%3D12'f%5C%5DV%5Cta%5C%3D10'%3D0'%3D500'%3D497'dim'%5C%3D10'%3D10'%3D500'%3D497'vdim'%5Cbox1'b%5Cva%5CF6F6F6'fC%5CC8C8C8'eC%5C'a%5C%5Do%5CLauto'f%5C&amp;sig=5h8cTJ4DH46uh2-T_A5PWwHScis" data-igsrc="http://7.gmodules.com/ig/ifr?mid=7&amp;synd=trogedit&amp;url=http%3A%2F%2Fgoo.gl%2FGGBZS&amp;up_gistId=7912846&amp;h=500&amp;w=100%25" data-type="ggs-gadget" data-props="align:left;borderTitle:coloc_simpleFAST.ijm;height:500;igsrc:http#58//7.gmodules.com/ig/ifr?mid=7&amp;synd=trogedit&amp;url=http%3A%2F%2Fgoo.gl%2FGGBZS&amp;up_gistId=7912846&amp;h=500&amp;w=100%25;mid:7;scrolling:no;showBorder:true;showBorderTitle:true;spec:http#58//goo.gl/GGBZS;up_gistId:7912846;width:100%;" width="500" height="500" style="display:block;text-align:left;margin-right:auto;" class="igm"><br>
</p>


<https://gist.github.com/cmci/7912846>

比較すると、最初のマクロにあった

    for (ypos = 0; ypos < hh; ypos++){
        for (xpos = 0; xpos < ww; xpos++){

のループのうち、xposによるループが削除されているのがわかるだろう。次にループの中身をみてみよう。最初に登場するのは

    makeLine(0, ypos, ww-1, ypos);

である。これは線選択領域(line ROI)を作成するための関数で、4つの引数は始点と終点の座標である。y軸の位置はyposでループごとに一行ずつさがっていくことになる。x座標は始点と終点の位置が常に一定で、左端(0)から右端(ww-1、すなわち幅よりも1ピクセル小さい数)まで水平に線選択領域が設置されることになる。次にsetSlice(1)によってチャネル1が選ばれ、getProfile()関数で、線選択領域のピクセル値が配列として変数paに格納される。ここから下4行は、ifを使った分枝になっている。最初のループのときにだけ、配列paがch1Aにコピーされる。以降のループでは、配列ch1Aに、paとして取得した各行のピクセル値の配列が付加される。

この配列の付加（concatenation）に使われる関数がArray.concatである。2つの引数をもち、返り値は連結された配列となる。試みに次のようなマクロを書いて自分で試してみると良い。

    a = newArray(1, 2, 3, 4, 5);
    b = newArray(10, 20, 30, 40, 50);
    c = Array.concat(a, b);
    Array.print(c);

ログウィンドウに、連結された配列が出力されるはずである。なお、これはつぎのように書いても良い。

    a = newArray(1, 2, 3, 4, 5);
    b = newArray(10, 20, 30, 40, 50);
    a = Array.concat(a, b);
    Array.print(a);

小さなちがいであるが、Array.concatの返り値がcではなく、aになっている。なにやらトートロジーめいているので、理解し難いかもしれない。これはほぼあらゆるプログラミング言語でそうなのであるが、まず右辺が評価され、その結果が返り値として左辺に代入される。このため、右側でaを計算で使ったあとにすべての結果をaに戻せば、aが上書きされることになるのである。

さて、本題に戻ろう。以上でチャネル1の取得の概要を説明したのであるが、同じことをチャネル2で行えば良い。処理は同等であり、データを集める配列だけがch2Aとなっている。

ループはこれで終了である。そのあとの共局在プロットの部分は、連載で紹介したマクロと全く一緒なので、説明を省く。

上のマクロを実行するとすぐに気づくと思うが、圧倒的に速度が向上する。ベンチマークを比較してみよう。最初の各ピクセルを測定して配列に格納してゆくマクロの場合はつぎのような処理時間がかかる。5回の試行をそのままリストする。

    Processing Time 3188 [msec]
    Processing Time 3280 [msec]
    Processing Time 3186 [msec]
    Processing Time 3548 [msec]
    Processing Time 3370 [msec]

ループを減らして高速化した場合はどうだろうか。

    Processing Time 68 [msec]
    Processing Time 69 [msec]
    Processing Time 67 [msec]
    Processing Time 67 [msec]
    Processing Time 67 [msec]


比較すると、前者がおよそ3秒かかっているのに比較して、後者では0.07秒に改善されている。ループの数を考えれば、x方向の76回のループが省略されるので76倍ほど速度が向上してもおかしくないが、およそ40倍という結果は期待される性能向上よりも少々低い。おそらく、配列の連結、条件分枝(if-else)といった若干複雑な計算が、今回の程度の性能向上にとどまっている理由であると思われる。なお、上記のような処理速度の比較を行う際にはgetTime()関数を使う。処理前、処理後にその時点での時間をミリ秒単位で取得し、処理後にその差を計算すれば良い。次のリンク先に、ベンチマークをとった際のコードを示すので、どこで時間を取得しているか確認するとよい。

<https://gist.github.com/cmci/7914175>

なお、高速化の手段としてより広く有効なのがバッチ・モードである。画像をディスプレイ上に表示するのはかなり時間のかかる過程である。この表示を行わないようにすることでかなりの高速化をはかることができる。画像処理によって再描画が繰り返しおきるような過程を

    setBatchMode(true);
    //what ever treatments …
    setBatchMode("exit and display");
    
のようにしてバッチモードの開始、バッチモードの終了のコマンドに挟むと、かなりの速度向上がみられることが多い。今回の場合もためしてみたが、あまり速度は向上しなかった。今回のようなチャネルの切り替えの場合には、バッチモードがそもそも意味をなさない（いずれにしても表示が切り替わる）からであろうと思われる。

##さらに高速化する:Javaオブジェクトに直接アクセスする

さらなる高速化は可能だろうか？このためには、Javaのオブジェクトに直接アクセスする必要がある。というのも、全ピクセルを一次元の配列として一発で取得できるので、あとはそれをプロットすればよい、ということになるのである。このためにJythonを使ってみよう。なお、Jythonに関しては、また別のページで解説するよていである。

リンク(ToDo)

さて以下にJyhtonのスクリプトを示す。

<p><img src="https://www.google.com/chart?chc=sites&amp;cht=d&amp;chdp=sites&amp;chl=%5B%5BGoogle+Gadget'%3D20'f%5Cv'a%5C%3D0'10'%3D499'0'dim'%5Cbox1'b%5CF6F6F6'fC%5CF6F6F6'eC%5C0'sk'%5C%5B%22Derquinse+Gist.GitHub+Gadget%22'%5D'a%5CV%5C%3D12'f%5C%5DV%5Cta%5C%3D10'%3D0'%3D500'%3D397'dim'%5C%3D10'%3D10'%3D500'%3D397'vdim'%5Cbox1'b%5Cva%5CF6F6F6'fC%5CC8C8C8'eC%5C'a%5C%5Do%5CLauto'f%5C&amp;sig=Jm_TFNyZRtdXs2NVW6lwt3nZFZg" data-igsrc="http://48.gmodules.com/ig/ifr?mid=48&amp;synd=trogedit&amp;url=http%3A%2F%2Fgadgets.derquinse-commons.googlecode.com%2Fgit%2Fgist-github%2Fgist-github-gadget.xml&amp;up_gistId=7914891&amp;h=400&amp;w=100%25" data-type="ggs-gadget" data-props="align:left;borderTitle:coloc_simple.py;height:400;igsrc:http#58//48.gmodules.com/ig/ifr?mid=48&amp;synd=trogedit&amp;url=http%3A%2F%2Fgadgets.derquinse-commons.googlecode.com%2Fgit%2Fgist-github%2Fgist-github-gadget.xml&amp;up_gistId=7914891&amp;h=400&amp;w=100%25;mid:48;scrolling:no;showBorder:true;showBorderTitle:true;spec:http#58//gadgets.derquinse-commons.googlecode.com/git/gist-github/gist-github-gadget.xml;up_gistId:7914891;width:100%;" width="500" height="400" style="display:block;text-align:left;margin-right:auto;" class="igm"><br>
</p>


<https://gist.github.com/cmci/7914891>

このスクリプトの速度をマクロと比較してみよう。以下のようなベンチマークである。

    Processing Time 3 [msec]
    Processing Time 2 [msec]
    Processing Time 2 [msec]
    Processing Time 2 [msec]
    Processing Time 2 [msec]

マクロに比較しておよそ1000倍ないしは30倍の速度向上になっていることがわかるだろう。まったくすばらしい、といいたいところであるが、実戦的な場面では、プロットなどの描画で体感速度はあまりかわらない結果になるだろう。とはいえ、描画を要しないような処理の場合には、処理速度に圧倒的な差が生じる。