# Shogi Library for Ruby [![Build Status](https://secure.travis-ci.org/myokoym/shogi-ruby.png?branch=master)](http://travis-ci.org/myokoym/shogi-ruby)

Ruby用の将棋ライブラリです。

## 用途
### 向いていること
* 将棋盤の簡単なコンソール表示
* GUIアプリケーションの内部状態の管理

### 向いていないこと
* 速度的に、思考エンジンのデータ構造には向きません。

## 機能
### できること
* CSA形式で、将棋盤オブジェクトを作成、操作、表示できます。
* 駒の動きが正しいかどうかチェックできます。

### まだできないこと
* 二歩チェック
* 行きどころのない駒のチェック
* 詰みチェック
* 手番の管理
* 棋譜の管理
* USI形式との相互変換

## Installation

Add this line to your application's Gemfile:

    gem 'shogi-ruby'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shogi-ruby

## Ruby Version

Ruby 2.0.0 or later. (and 1.9.3)

## Usage

    require 'shogi'

    board = Shogi::Board.new
    puts board.to_csa
    #=> P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
        P2 * -HI *  *  *  *  * -KA * 
        P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
        P4 *  *  *  *  *  *  *  *  * 
        P5 *  *  *  *  *  *  *  *  * 
        P6 *  *  *  *  *  *  *  *  * 
        P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
        P8 * +KA *  *  *  *  * +HI * 
        P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
        P+
        P-

    board.move("+7776FU", :csa)
    puts board.to_csa
    #=> P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
        P2 * -HI *  *  *  *  * -KA * 
        P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
        P4 *  *  *  *  *  *  *  *  * 
        P5 *  *  *  *  *  *  *  *  * 
        P6 *  * +FU *  *  *  *  *  * 
        P7+FU+FU * +FU+FU+FU+FU+FU+FU
        P8 * +KA *  *  *  *  * +HI * 
        P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
        P+
        P-

    board.move("-3334FU", :csa)
    board.move("+8822UM", :csa)
    board.to_csa
    #=> P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
        P2 * -HI *  *  *  *  * +UM * 
        P3-FU-FU-FU-FU-FU-FU * -FU-FU
        P4 *  *  *  *  *  * -FU *  * 
        P5 *  *  *  *  *  *  *  *  * 
        P6 *  * +FU *  *  *  *  *  * 
        P7+FU+FU * +FU+FU+FU+FU+FU+FU
        P8 *  *  *  *  *  *  * +HI * 
        P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
        P+00KA
        P-

    board.default_format = :csa
    board.move("-3122GI")
    board.move("+0055KA")
    board.to_csa
    #=> P1-KY-KE-GI-KI-OU-KI * -KE-KY
        P2 * -HI *  *  *  *  * -GI * 
        P3-FU-FU-FU-FU-FU-FU * -FU-FU
        P4 *  *  *  *  *  * -FU *  * 
        P5 *  *  *  * +KA *  *  *  * 
        P6 *  * +FU *  *  *  *  *  * 
        P7+FU+FU * +FU+FU+FU+FU+FU+FU
        P8 *  *  *  *  *  *  * +HI * 
        P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
        P+
        P-00KA

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
