#Jythonの基礎

## 序論
ImageJには独自のマクロ言語が実装されており、多くの作業はマクロで記述可能である。とはいえImageJのマクロはGUIを経由したスクリプトであるため、ヘッドレス（GUIなし）で使用する際にはさまざまな制限が生じる。また、マクロの関数が用意されていないプラグインを使う場合などに不自由を感じることがある。これらの問題があるときにはJavaの仕様（APIと呼ばれる）に直接アクセスできるスクリプト言語を使う必要がある。

ImageJにおけるスクリプティング言語としては他にJavascript(Rhino)や、Jython
(Javaで実装したPython)などがある。処理速度を高めたいならば、ClojureもしくはScalaを使う。JavascriptはImageJにおいてそのまま使うことが出来る。また、Javascriptはコマンドレコーダの記録言語としても実装されており、マクロと同じように記述することができる。ただしこの場合の運用は、マクロと同程度の機能に限られるので、Javadocを駆使しながらコーディングを行うのでなければマクロでプログラムを書くことをお勧めする（今回の実習ではマクロの学習は割愛する）。

JythonはPythonの文法であること、Jython自体に実装されているさまざまな機能があることから（特に文字列操作、ファイルシステムへのIOにおいてさまざまなメリットがある）、Jythonを使う研究者が多い。ImageJではJythonのファイルを実行した時にJythonのライブラリが存在しないことがわかると、ImageJはJythonのライブラリを自動的にダウンロードする。Fijiでは最初からJythonが導入されている。

今回はJythonによるスクリプティングを学ぶ。ImageJのさまざまなクラス群（ImageJはそれぞれ特定の機能をもつJavaでプログラムされたクラスが複数集まった存在であると考えると良い）を扱うには、クラス群の諸機能を参照するためのレファレンスが必要になる。Javadocと呼ばれる仕様書（ImageJの場合にはImageJのJavadoc）がこれにあたり、プログラミングの基本を習得したあとはJavadocを繰りながらスクリプトを書くことになる。ImageJのJavadocは次のリンク先にある。

<http://imagej.net/developer/api/>

##参照になるページ

Jythonそのものに関しては、

<http://www.jython.org/docs/>

以下のリンクは、今後JythonでImageJ/Fijiのスクリプティングを行う際に参考になるページである。

[Jython Tutorial @ Fiji wiki](http://fiji.sc/Jython_Scripting)

[Jython Cookbook @ CMCI](http://cmci.embl.de/documents/120206pyip_cooking/python_imagej_cookbook)


## はじめの一歩

### スクリプトエディタの使い方

スクリプトエディタ(Script Editor)はFijiのメニューから

[File > New > Script]

を選ぶことで開始できる。より簡便には

Ctrl-L (win)

Command-L (osx)

のショートカットキーでコマンドファインダを呼び出し、'Editor'と入力すると、Script Editorがトップに選ばれるのでそれを選択しリターンキーを押せば良い。

スクリプトエディタには独自のメニューがついている。そのうちの一つが'language'であり、この項目をクリックして、'Python'を選ぶことで、Jythonのコマンドを解釈させることができるようになる。

エディタは上下ふたつのパネルにわかれており、上がスクリプトを入力するテキストフィールド、下が出力フィールドになっている。間にはRunボタンが左側に、右側にはStdout（通常の出力）とStderr（エラー出力）の二種を選ぶボタンがあり、デフォルトでは通常の出力が表示される。

### Hello World

スクリプトエディタのテキストフィールド（上部）に以下のように入力する。

````
print "Hello World!"
````

左下にある'Run'ボタンをクリックすると、下側のテキストフィールドに

````
Hello World!
````

と表示されるはずである。この場合、出力先はスクリプトエディタである。`print`はJythonのコマンドであり、そのあとのスペースに続く文字列ないしは数字を出力せよ、というコマンドである。

出力先をImageJのログウィンドウにしたい場合は

````
IJ.log("Hello World!")
````

とする。この場合の表記はprintの場合とことなり、IJ.logというコマンドのあとに出力される文字が括弧で囲まれている。これは、IJ.logがJavaの機能であるため、このようなことになる。IJ.logというコマンドについての詳細は後述する。

さらにコマンドを付け加えてみよう。

````
IJ.log("Hello World!")
IJ.log("\\Clear")
````

なおバックスラッシュ(``\``)は日本語のOS環境では、円記号（¥）として表示される。機能的には同等の役割を果たす。

この二行のコードを実行（Runをクリックすること）すると、ログウィンドウにはなにも表示されない。一行目と二行目を入れ替えてみる。

````
IJ.log("\\Clear")
IJ.log("Hello World!")
````

この場合には、Hello Worldが表示される。``\\Clear``は最初にバックスラッシュが２つ連続して存在することによって、テキストそのものではなく、一種のコマンドを意味することになる（``\\``はエスケープシークエンスと呼ばれる）。``\\Clear``はログウィンドウをクリアしてまっさらにせよ、というコマンドである。

上の二行のコマンドの２つの例における出力の差がプログラミングの本質である。すなわち、コマンドは上から下にむかって次々に実行される。したがってどのような順番でコマンドが書かれているか、ということが出力の内容を決定する。


## 変数の扱い

さて、次の一行を入力して実行してみよう。

	print 1 + 2
	
出力パネルに

	3

と表示されるはずである。これは、`print`コマンドに続く数式を、数字として計算した後にその結果がプリントされている。次のように書き換えて実行してみよう。

	a = 1
	b = 2
	c = a + b
	print c
	
出力パネルには先ほどと同じく３が表示されるはずである。ただしこの場合、最初に変数``a``に1が代入され、次に``b``に2が代入され、３行目ではこれらの変数を使って加算が行われその結果が変数``c``に代入されている。最後の行ではこの変数``c``がコマンド``print``に渡されて、cが保持している値が出力される。

>演習：aの値、bの値を別の数に変えて、出力結果が変わることを確かめよ。

以上は数字である。変数には数字ではなく、文字列を代入することもできる。

	a = "Hello"
	b = " World"
	c = a + b
	print c
	
出力は``Hello World``となっているはずである。ここで注意して欲しいのは三行目の“数式”である。ここではプラスのサインがaとbの間にあるが、起こることは算数の足し算ではない。aの文字列の後にbが追加される(concatenateという)。Helloとworldの数学的な足し算がなにを結果するのかはわからないが、普通そのような足し算はしない。そこで、スクリプトを解釈しているJythonインタプリタ（解釈機）は、変数が保持している値が数字であるか文字列であるかを分別してプラスサインがなにを実行するのかを切り替えていることがわかる。

文字列であることは、ダブルクオートで文字を囲むことによって明示している。このことから次のようなこともできる。

	a = "1"
	b = "2"
	c = a + b
	print c
	
この出力結果は

	12

となる。なぜならば、数字の1と2がそれぞれダブルクォートで囲まれているため、ナマの数字ではなく文字列の数字として変数に格納されることになるから、三行目のプラスサインは算数ではなく文字列の追加として機能することになるからである。

さて、少々ここから発展させる。変数は、数字や文字列のみならず、画像などのより複雑な形式のオブジェクトも代入させ、そのオブジェクトを保持させることができる（オブジェクトは文字通り「モノ」とおもっていただければよい。あるいは「ブツ」でもよい）。たとえば、であるが、

	imp = IJ.openImage('/Users/miura/image.tif')

としたときには、impという変数に画像が与えられている。impを画像だ、と思って以降のスクリプトをしたためることになる。たとえばこれに続き

	imp.show()

と次の行に書くと、画像がデスクトップに表示されることになる。ここで詳しいことはかかないが、IJ.openImageは、画像ファイルを読み込むためのコマンド、その引数（括弧内の文字）はファイルの絶対パスである。また、``imp.show()``は、変数impに画像が与えられているため、画像に付随するコマンドshow()を実行せよ、ということであると理解してもらえればよい。より詳しい話は後ほど詳述する。

なお、絶対パス、とは、パソコンの中のその場所にそのファイルがあるかを示す住所のようなものである。パソコンを使っている人ならだれでも、ファイルがツリー上に構成されたフォルダの中のどこかにファイルを保存することを行なっているだろう。この場所がどこであるのかを示すのが絶対パスである。上の例``/Users/miura/image.tif``では、Usersフォルダの中のmiuraフォルダの中にimage.tifというファイルがあることを示している。スラッシュ``/``はパスセパレータと呼ばれ、フィルダの階層構造を上位から下位に向かってフォルダの名前ごとに区切る役割を果たしている。

なお、ウィンドウズにおける表記は若干ことなっている。たとえば``c:\\Users\\miura\\image.tif``は、CドライブのUsersフォルダの中のmiuraフォルダの中にimage.tifがあることを示している。この場合、パスセパレーターは、2つのバックスラッシュが担っている。

絶対パスとは別に相対パスという住所の表記法もある。はがきを送るのに郵便番号から始まる住所を書くが、家族に配達してもらうならば「二ブロック先を右に、三軒目の鈴木さん」という今いる場所から相対的に送り先を指定する宛名の書き方も可能だろう。ファイルのありかを書くのに「今いるフォルダから2つ上に上がってその下にあるGというフォルダの下のimage.tif」という表記も可能である。これを相対パスという。相対パスは、フォルダの上位構造が全く異なっていてもあるプロジェクトのフォルダの内部構造が同一であればそのプロジェクトのフォルダがどこに存在しているか関係がなくなる。プロジェクトのフォルダをあちらこちらに移動できるので便利である…のだが、今回は使わないので割愛する。


## リスト
ある数列をひとつのリストとしてまとめておくことが可能である。たとえば

	aa = [1, 3, 5, 17, 25]

とすると、aaは要素を５つもつリストとなる。個別の要素を取り出すには、リストを格納している変数（上の場合はaa）に続けてブラケットで要素のインデックスを指定する。インデックスはゼロから始まる。上の例で３番目の要素を取り出したければ、インデックスは２になる。上の行につづけて

	print aa[2]

とすると、５と出力されるはずである。すべての要素を出力したい場合、

	print aa

とすれば、リストがそのまま出力されるだろう。

>  演習　存在しないインデックスを指定して出力しようとすると、エラーが出ることを確認せよ。エラーを解読し、理解せよ。

###range()

数列をリストとして生成するには次のようにする。

	bb = range(10)
	print bb

とすると、出力には

>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

と出るはずである。``range(10)``は、0に始まり10以下までの整数の数列をリストとして生成せよ、というコマンドになる。

引数がひとつだけすなわちrange(n)の場合、0 <= k < n のｋが生成される。つねに0から始まる。最初の数字を任意のものに変えるには、引数をふたつにする。

	print range(5, 10)
	
とすると、

>[5, 6, 7, 8, 9]

と出力されるだろう。``range(n1, n2)``によって、n1 <= k < n2の整数kのリストが生成される。これまでの場合、数字の間隔はかならず1であったが、このステップサイズも引数を3個にすると三番目の引数として指定できる。


	print range(0, 10, 2)

出力は

> [0, 2, 4, 6, 8]

となるはずである。

###len()

リストの長さはさまざまである。長さを知るためには``len``という関数を使う。

	print len(aa)	
	print 'list length:', len(aa)

この一行目は単に数字の５を出力するだろう。この数字がなにかを示すために、二行目では最初にlist length: という文字列を加えた。printに与える引数はコンマで区切ればいくつでも可能である。コンマの位置には自動的にスペースが挿入される。自分で``print len(range(5))``などを試してみればすぐにわかるだろう。

###リストは数に限らない

ここまで紹介したリストは数のリストであった。とはいえ、リストの内容は数に限られない。たとえば、画像もリストに含めることができる。ここでは複数のチャネルを持つ一つの画像データを、それぞれのチャネルの画像のリストに変換してみよう。

[File > Open Samples > Hela Cells (1.3M, 48-bit RGB)]

によって3つのチャネルをもつ画像を開いて欲しい。次のスクリプトを書いてHela細胞の画像に関して実行する。

	imp = IJ.getImage()
	imps = ChannelSplitter.split(imp)
	print len(imps)
	imps[0].show()
	imps[1].show()
	imps[2].show()

一行目は、現在アクティブな画像を変数impとして得ている。二行目ではこの画像の各チャネルの画像を、impsというリストとして取得している。このリストが、数字ではなく画像を要素として保持しているリストの例である。三行目ではそのリストの長さを出力（3と出力されているはずである）。4行目から6行目では、それぞれのチャネルの画像を個別に表示している。リストの一番目の要素が赤のチャネル、二番目の要素が緑のチャネル、3番目の要素が青のチャネルである。

## ループ

リストの要素をそれぞれ独立に出力するにはつぎのようにする。
	
	aa = range(5)
	for a in aa:
		print a

すこしでもプログラミングをかじったことのある人ならば、「ああ、forをつかったループですね」と思うかもしれないが、知らない方々のために解説すると、上の一行目はすでに学んだように、0 <= k < 5の数列をリストとして生成している。次の行のforではじまる部分は、

>リストaaの各要素を変数aに順番に代入せよ、そして、要素ひとつ毎にその下に連なる行頭を字下げしたコードを実行せよ

という意味である。この簡単な例の場合、繰り返し実行されるのは三行目であり、aの内容を出力する。全体としてみればaaの要素が順繰りに出力されることになる。この場合一行だけだが、さらに同じように字下げしたコードがもし続くならば、それらもくりかえし実行される。例えば

	aa = range(5)
	for a in aa:
		print a
		print a*5

のようにすれば、ループ毎に二行出力されることになる。

上の場合は、rangeによって整数のリストを作成し、それでループを行っているが、リストであればその構成要素がなんであってもループさせることができる（プログラミングを知っているひとならばイテラブルなオブジェクト、といえばすぐにわかるかもしれない）。たとえば前項で扱った3チャンネル画像を分割して表示するスクリプトをforを使って書きなおしてみよう。

	imp = IJ.getImage()
	imps = ChannelSplitter.split(imp)
	print len(imps)
	for aimp in imps:
		aimp.show()

impsはImagePlusオブジェクトのリストである。したがってこれはそのままforループに供することが可能であり、ループ毎に変数aimpに要素が代入される。そしてループ毎に1番目のチャネルから3番目のチャネルまでが表示されるのである。

ImageJマクロ、ないしはCなどのプログラミングに慣れている人はおそらく次のような疑問にすぐに突き当たるだろう。

> 整数ではないリストをループさせるとき、インデックスを得たい場合にはどうすればよいのか？

ふたつの解決方法がある。ひとつはインデックスでループを回す方法である。上のコードを書き換えてみよう。

	imp = IJ.getImage()
	imps = ChannelSplitter.split(imp)
	print len(imps)
	for i in range(len(imps)):
		print "channel", i
		imps[i].show()
		
もうひとつの方法は、enumerateを使う方法である。こちらのほうがPythonらしい使い方である。

	imp = IJ.getImage()
	imps = ChannelSplitter.split(imp)
	print len(imps)
	for i, aimp in enumerate(imps):
		print "channel", i
		aimp.show()
		
注目して欲しいのはforの構文で返り値の変数が2つ、iとaimpになっていることである。iにはループのインデックスが入り、aimpにはリストimpsの要素が入る。

## 条件

変数やその状態を判別して、その状況に応じてなんらかの処理を行う、といったことをしたいときには、if ではじまる判定式を使う。具体的には次のようなことだ。

	a = 5
	if a == 5:
		print a
	
実行すると“5”という数字が出力されるだけであるが、これは二行目において、aが5であることを判定し、正しいことを確認した上でaが出力される。

この2行目は等号を2つ連ねた書き方をしている。これは真偽(true or false)を判定するための式で、たとえば次のような短いコードを書いてみよう。

	a = 5
	print a==5 

出力されるのは"True"である。一行目をa = 10と書き換えると、出力はFalseになるはずである。すなわち、a==5と書くことで"aは5か？"という疑問に真偽で解答するという形になっている。このことがわかれば次の（あまり意味がないが理解の助けにはなる）コードが理解できるだろう。

	a = 5
	if True:
		print a

この場合、二行目に意味はない。なぜならば判定式がなくつねにTrueだからである。したがってこれは

	a = 5
	print a

というコードと変わらない。また

	a = 5
	if False:
		print a
		
であれば、aがなんであってもなにも出力しない。

これらを理解できれば

	a = 10
	if a == 5:
		print a

の場合にはなにも起きないことは簡単に想像つくであろう。判定式が偽なので字下げの部分は実行されないのである。偽の場合にもなにか行うようにするにはelseを使う。

	a = 10
	if a == 5:
		print "a is 5"
	else:
		print "a is not 5"

のように、elseによって付け加える。応用問題になるが

	a = 10
	if False:
		print "a is 5"
	else:
		print "a is not 5"
		
の場合にはどうなるか？

常に"a is not 5"という出力がおきる。

より実際的なifの例を次にみてみよう。

	filename = "image.tif"
	if filename.endswith(".tif"):
		print "This file is a tiff file"

この場合、判定式はコマンドそのもので、文字列filenameが".tif"で終わっている、ということが真であるか偽であるかを判定するメソッドである。こうしたメソッドは、レファレンスサイトに行くとみつけることができる。文字列に関するページは

<http://docs.python.org/release/2.5.2/lib/string-methods.html>

である。endsWithとともにさまざまなメソッドを文字列に対して処理することができるのがわかるだろう（なお、Python2.5を参照にすれば、Jythonで実装されている機能と同じである）。



## ファイルシステムへのアクセス

ファイルシステムにアクセスしてファイルのリストを取得する。いくつもの方法があるが、ここではJythonに実装されているosパッケージのos.walk関数を使う。

	srcDir = DirectoryChooser("Choose!").getDirectory()
	IJ.log("directory: "+srcDir)
	for root, directories, filenames in os.walk(srcDir):
	    for filename in filenames:
	        if filename.endswith(".tif"):
	            path = os.path.join(root, filename)
	            IJ.log(path)
	            imp = IJ.openImage(path)
	            imp.show()
	            imp.close()

解説

- DirectoryChooserはImageJのクラスである。ここではDirectoryChooserのインスタンス化と、そのメソッドの使用を一行で行なっていることに注意。すなわち`dc = DirectoryChooser("please select a folder")`というコンストラクタによるインスタンス化を行ったあとに、そのことで生成したオブジェクト（dc）を使う`srcDir = dc.getDirectory()`という２つのステップが一行でなされている。この一行で書いてしまう書き方はスクリプティング的である。Javaではこのようなことができない。

os.walkの結果をforループで展開するのは、ディレクトリを再帰的に探索するためである。

## 画像の扱い方


### IJクラス　-スタティックなアクセス

IJクラスにはスタティックなメソッドが多くリストされている。クラスとは、機能（メソッドと呼ばれる）や変数（フィールドと呼ばれる）をまとめたひとつのまとまりである。たとえば

IJ.beep()

は、IJクラスの中のひとつのメッソッド（beep()）であり、これを実行すると音がなる。

- Javadocの使い方

IJクラスのメソッドはほとんどが「スタティック」である。これは、クラスをインスタンス化しなくても、そのメソッドを使えることを意味している。インスタンス化とは、いわばそのクラスのスペックを鋳型とするクローンを作ることを意味しており、いくつも似たようなクローンを作ることができる。たとえば、ImageJでは、画像はすべてImagePlusというクラスのインスタンスである。ことなる画像であっても、同じクラスに属している、ということである。画像の大きさはことなっていいても、幅と高さという属性をいずれも所持しており、こうした点において「同じクラス」なのである。

### コマンドレコーダ

IJ.run()メソッドは、メニューの項目を指定して実行する。二番目の引数であるオプションは、通常であればダイアログボックスで入力する内容を指定する。

### ImagePlus

ImagePlusは画像そのものと画像の属性（スケールやmultitiff）などを含むクラスである。デスクトップに開いた画像オブジェクトをグラブする際にもImagePlusのオブジェクトを取得することになる。また慣例的なことであるが、変数はimpとすることが多い。
	
	imp = IJ.getImage()
	frames = imp.getStackSize()
	IJ.run("Set Measurements...", "  mean redirect=None decimal=3")
	IJ.run("Clear Results");
	for i in range(frames):
		imp.setSlice(i + 1)
		IJ.run("Measure")
		
このコードではスタックの画像オブジェクトimpとしてグラブし、そのスライスを一枚一枚めくりながら測定を行っている。
		

### ImageProcessor

ImageProcessorは、ImagePlusの属性の一部であり、画像そのもののクラスである。さまざまな画像処理のアルゴリズムをメソッドとして所持している。実際にフィルタをかけたりするのはこのクラスのオブジェクトで行う。スタック画像の場合、ImagePlusのオブジェクトの中に複数のImageProcessorオブジェクトが入っている、とかんがえるとよいだろう。

### 輝度プロファイルの例

輝度プロファイルを得る場合にはProfilePlotクラスをインスタンス化する必要がある。このインスタンス化の際に、現在トップにある画像を指定すれば、そのまま輝度プロファイルを取得することができる。


	imp = IJ.getImage()
	pf = ProfilePlot(imp)
	profile = pf.getProfile()
	for val in profile:
		print val
		
このスクリプトの結果をさらにCSVに出力してみる。Jythonのcsvパッケージが簡便なので使ってみる。

	import csv
	
	imp = IJ.getImage()
	pf = ProfilePlot(imp)
	profile = pf.getProfile()
	for val in profile:
		print val
	f = open('/Users/miura/Desktop/prof.csv', 'wb')
	writer = csv.writer(f)
	for index, val in enumerate(profile):
		writer.writerow([index, val])
	f.close()
	
標準でロードされないパッケージは、上記のようにimportで明示的にロードする必要がある。ImageJのクラスもおなじようにimport文で宣言する必要があるのだが、Fijiのスクリプトエディタでは立ち上がりのときにバックグランドでimportを行っており、この部分がかくされている。たとえば

	from ij import IJ, ImagePlus
	
とかく必要がないのである。コマンドラインから直接使う場合、たとえば

	fiji test.py
	
	ないしは
	
	jython test.py

といった使い方をする場合には、インポート文を加えておく必要があるので要注意である。


