#プラグインのインストール

ImageJではプラグインと呼ばれるファイルを追加することで、あらたな画像処理・解析機能を追加することができる。追加の方法は簡単で、

1. 追加したい機能のプラグインをダウンロードする。
2. ファイルをImageJのフォルダーの直下にあるpluginsフォルダーに移動もしくはコピーする。
3. ImageJをリスタート、ないしは[Help > Refresh Menu]を実行する。

大抵の場合は、この作業の後に新しいメニューアイテムが[Plugins >]の下に追加されるので、即座に使用可能となる。

上の手順がよくわからない、という方はこちらのリンク先に詳しく書かれているので、参照されたい。

<http://life-science-project.com/1018/>

このリンク先のページに書かれていない詳細があるので、以下追加情報ということで書き加える。

##プラグインのファイル形式

###.javaファイル

ソースコードそのもので、このファイルのままでは実行されない。[Plugins > Compile and Run…] で、ソースコードを指定することでコードがコンパイルされて.classファイルになる。

例：/plugins/Graphics/Example_Plot.java

このファイルは、プラグインフォルダの中にあるGraphicsというフォルダにある。なお、現在のフォルダがImageJであることを前提にしている。以下も同様である。

###.classファイル
プラグインのファイル形式でもっとも単純なものは、拡張子が.classのファイルである。これはJavaで書いたコードをコンパイルしたそのままのものである。

例：……/ImageJ/plugins/Graphics/Example_Plot.class

Graphicsフォルダに入っているので、メニューでは

[Plugins > Graphics > Example Plot]として表示される。

###.jarファイル
ソースコードがいくつものクラスを使用している場合には、これをまとめた.jarというファイルになる。このファイル形式はzipと同様の圧縮形式で、zip解凍ソフトなどを使えば、中身のファイルにアクセスすることができる。ただし、実際に解凍することはほとんどない。コマンドラインからは次のようにすると、jarファイルの中身をリストすることができる。

	jar tf <filename>.jar

例としては次のようになる。

	(pwd > /Applicaitons/ImageJ) # OSXでの例
	jar tf /plugins/Input-Output/Animated_Gif.jar
	
出力結果は以下である。

	AnimatedGifEncoder.class
	Animated_Gif_Reader.class
	Animated_Gif_Reader.java
	Animated_Gif_Writer.class
	Animated_Gif_Writer.java
	GifDecoder.class
	GifFrame.class
	LZWEncoder.class
	NeuQuant.class
	plugins.config

クラスファイル(.class)とそのソースコード(.java)から構成されているが、その他のファイルであるplugins.configはメニューツリーにおいてアイテムが現れる位置を指定する設定ファイルである。このファイルだけを抽出して中を見てみよう。

	jar xf /Applications/ImageJ/plugins/Input-Output/Animated_Gif.jar plugins.config
	cat plugins.config

出力は

	# Description:
	# These plugin open an animated gif as a stack and
	# and save a stack as an animated gif. They are
	# installed as the File>Import>Animated Gif...
	# and File>Save As>Animated Gif commands.
	
	# Authors:  Kevin Weiner and  Ryan Raz
	# Date: 2007/06/28
	
	# Generate the jar file using: "jar cvfM Animated_Gif.jar *"
	
	File>Import, "Animated Gif...", Animated_Gif_Reader
	File>Save As, "Animated Gif... ", Animated_Gif_Writer

シャープではじまる行はコメントなので、機能とは直接関係ない。最後の二行が、プラグインがメニューツリーのどこに現れるかを指定している。この場合には、[File > Import > Animated Gif…]および[File > Save As > Animated Gif…]として機能が追加される。

###.ijmファイル.txtファイル
ImageJマクロ言語で書かれたファイルである。ファイルの名前にアンダースコア（_）を入れ、プラグインフォルダに置くと、プラグインのアイテムとしてメニューに現れるようになる。

例：　……/ImageJ/plugins/Macros/Show_All_LUTs.txt

###.jsファイル、.pyファイル
それぞれJavascriptないしJythonで書かれたプラグインのファイルである。これらのファイルでも、ファイルメニューにアンダースコアを加える事でメニューに現れるようになる。


