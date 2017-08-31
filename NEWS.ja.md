# お知らせ

## 0.1.0: 2017-08-31

### 変更点

* 改良
  * SFEN（USI）形式の出力をサポートしました。[Shigeaki Matsumuraさんがパッチ提供]
    * Added `Game#to_usi`.
    * Added `Game#to_sfen` (the alias of `Game#to_usi`)
    * Added `Board#to_usi`.
    * Added `Board#to_sfen`. (the alias of `Board#to_usi`)
    * Added `Board#usi_captured`.
    * Added `Board#sfen_captured`. (the alias of `Board#usi_captured`)
  * Ruby 2.0.0のサポートをやめました。
* TODO
  * SFEN（USI）形式の入力（`Board#move_by_usi`）をサポートする

### Thanks

* Shigeaki Matsumuraさん

## 0.0.9: 2016-06-24

### Changes

* Improvements
  * Improved mevement error detection. [Patch by Shigeaki Matsumura]
  * Implemented Nifu restriction in `move_by_csa`. [Patch by Toru YAGI]

### Thanks

* Shigeaki Matsumura
* Toru YAGI

## 0.0.8: 2015-05-31

### Changes

  * Improvements
    *  Supported Bundler.require (require "shogi-ruby").
    *  Added Board.register and Cell.register as plugin system.
    *  Removed a deprecated method `move_from_csa`.
  * Fixes
    *  Fixed error messages.

## 0.0.7: 2013-10-29

### 変更点

  * 修正
    * 七段目に入る駒と七段目から出る駒が成れなかった問題を修正
      [Yoshiyuki Kawashimaさんがパッチ提供]

### 感謝

  * Yoshiyuki Kawashimaさん

## 0.0.6: 2013-08-29

### 変更点

  * 改良
    * Board#atメソッドを追加
