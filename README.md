# iOS-DialView

タッチ操作で回る view.

## DialView クラス
* 自身へのタッチ操作により、自身の transform を操作して回転する  
（したがってこの View のtransformは変更したらダメです）.
* タッチ操作は layer.anchorPoint を中心に判定するのでだいたい直感的に回る.
* 慣性で回り続ける＆止まる
* ついでにタッチ判定を簡単に円形にできる（roundedHitRadiusプロパティ）.

## ValueDecelerator クラス
* 値をひとつ慣性で変化させる.
* CADisplayLinkドリブンなのでアニメーション向け.

