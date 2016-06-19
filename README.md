# Shogi Library by Pure Ruby [![Build Status](https://secure.travis-ci.org/myokoym/shogi-ruby.png?branch=master)](http://travis-ci.org/myokoym/shogi-ruby) [![Gem Version](https://badge.fury.io/rb/shogi-ruby.png)](http://badge.fury.io/rb/shogi-ruby)

Ruby用の将棋ライブラリです。

## 特徴

* Rubyのみで記述されています。
  * デバッグが楽です。
  * インストールが楽です。
* CSA形式に対応しています。
  * コンピュータ将棋協会が推奨する標準形式です。

## 用途

### 向いていること

* 将棋盤の簡単なコンソール表示
* GUIアプリケーションの内部状態の管理

### 向いていないこと

* 速度的に、思考エンジンのデータ構造には向きません。

## 機能

### できること

* CSA形式で、将棋盤オブジェクトを作成、操作、表示
* 駒の動きが正しいかどうかのチェック
* 棋譜の管理

### まだできないこと

* 行きどころのない駒のチェック
* 詰みチェック
* 手番チェック
* USI形式との相互変換

## Installation

Add this line to your application's Gemfile:

    gem 'shogi-ruby'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shogi-ruby

## Ruby Version

Ruby 2.0.0 or later.

## Usage

### Introduction

* 使う準備

        require 'shogi'

* 対局を管理するクラス

        Shogi::Game

* 盤面を管理するクラス

        Shogi::Board

* 局面の情報をCSA形式で取得するメソッド

        Shogi::Game#to_csa
        Shogi::Board#to_csa

* 駒を動かすメソッド

        Shogi::Game#move
        Shogi::Board#move

### Tutorial

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

    game = Shogi::Game.new
    puts game.to_csa
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
        +

    game.move("+7776FU", :csa)
    puts game.to_csa
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
        -

    game.move("-3334FU", :csa)
    game.move("+8822UM", :csa)
    puts game.to_csa
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
        -

    game.default_format = :csa
    game.move("-3122GI")
    game.move("+0055KA")
    game.show
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
        -

    puts game.kifu
    #=> +7776FU
        -3334FU
        +8822UM
        -3122GI
        +0055KA

    puts game.at(3).kifu
    #=> +7776FU
        -3334FU
        +8822UM

    game.at(3).show
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
        -

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
