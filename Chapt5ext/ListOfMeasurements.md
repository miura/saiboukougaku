#機械学習のモデル

確認テスト2で筆者が使用した分類モデルは下のリンクからダウンロードできる。

<https://sites.google.com/site/imagejjp/articles/session5/classifierysi.model?attredirects=0&d=1>

# 測定項目のリスト

[Set Measurements…] で選択できる測定項目を以下、リストする。括弧内は、Resultsウィンドウに結果が表示される際のヘッダー名である。

- Area (Area): 面積。スケールが既知でSI単位で計算されているときと、単にピクセル数で表示されている場合があるので要注意。

- Standard Deviation (StdDev): 輝度の標準偏差。

- Min & max gray value (Min, Max): 輝度の最小値・最大値。

- Integrated Density (IntDen, RawIntDen): 輝度の平均値 x 面積。SI単位で面積が実測されている場合には、RawIntDenが表示されこれが単純な輝度の総和である。面積の単位がピクセル数の時にはIntDenが輝度の総和である。

- Mean gray value (Mean): 輝度の平均値。

- Centroid (X, Y): 幾何学的な重心。領域に含まれるすべてのピクセルの座標の平均値。

- Modal gray value (Mode): 輝度のモード。もっとも出現頻度の高い輝度。

- Perimeter (Perim.): 輪郭の長さ。

- Fit ellipse (Major, Minor, Angle): 領域にフィットさせた楕円の主軸と副軸の長さ。Angleは主軸と複軸の間の角度。 

- Center of mass (XM, YM): 物理的な重心。輝度の重みをつけた座標の平均値。

- Bouding rectangle (BX, BY, BW, BH): 領域を収める最小の長方形の左上コーナーの座標、及び幅・高さ。

- Shape descriptors: 以下の4種類の形態記述子を計算する。

	- Cicularity (Circ): 真円度。4π x 面積 / (輪郭長)^2。1.0は真円であり、0.0に近づくほど長細い形になる。

	- Aspect Ratio (AR): アスペクト比。フィットした楕円の主軸を副軸で割った値。

	- Roundness (Roundness): 円形度。4 x 面積 /π/ (主軸長)^2。

	- Solidity (Solidity): 凸度。形態のへこみの少なさを表す数値である。凸包(Convex Hull)処理と関連している。凸包処理によって任意の領域はすべて凸型の輪郭によって領域を包み込む。直感的には領域のへこんだ部分がなくなるようなアウトラインを引く、ということになる。このさいに、元の領域の面積を、凸包処理したあとの面積で割ると、へこみがおおきければ小さい値、凹みがすくなければ1.0に近づく。

- Feret's diameter (Feret): フェレット径。領域を点集合とした時に、その中で最も遠い点の間の距離。

- Median: 輝度の中央値。

- Skewness (Skew): 輝度の3次のモーメント。輝度のヒストグラムの分布が左右に対称だと0になる。左にテイリングしていると負に、右にテイリングしていると正になる。

- Kurtosis (Kurt): 輝度の4次モーメント。輝度のヒストグラムの分布が正規分布だと0、より広がっていると負、より鋭いピークであれば正になる。

- Area fraction (%Area): 閾値選択[Threshold…]を行っている画像であれば、その閾値で選択されている領域の画像全体に対する百分率。閾値選択を行っていない画像では、0ではない輝度を持つピクセルの数の、全ピクセル数に対する百分率。

- Stack Position (Slice, Ch, Frame): スタックの中での位置。たとえばZスタックであれば、3枚目はSlice=3となる。