# フィルターの使い方 1

生物学の問題を常に意識して画像解析の説明にならないように。



フィルタそのものは重大な関心事項であるが…　フィルタリングは画像解析のために行う。
解はひとつではない。さまざまな組み合わせが可能。
フィルタをかけたものは、多くの場合、輝度の定量に適していない。分節化の前処理として行われる場合がほとんどである。オブジェクト認識、特徴抽出
マスクの概念の説明
分節化された画像をマスクして、定量。

convolution, non-linear filters

	画像処理
		画像改善（お肌をきれいにみせる）
		特に分節化（オブジェクトを抽出する）を行うための画像処理にふれる。
	平滑化(smoothing)・鮮鋭化(sharpening)
	ノイズを除く話。（メディアンフィルタ）
	離散フーリエ変換の簡単な説明
	数理形態演算（morphological processing）
	距離変換画像　(distance transformation) > watershed （分水嶺変換）
	
	骨格化　：　線虫で長軸を抽出する。
	核膜上のタンパク質の定量（morphhological filtering dilate - erode）
	

蛍光シグナルの抽出
解析・バックグランドの引き算、unsharp mask (pseudo high pass filtering)
スクリプト
