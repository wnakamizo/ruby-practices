#!/usr/bin/env ruby

=begin
## オプションなしで実行すると、行数・単語数・バイト数・ファイル名の順に表示
-l：行数（改行の数）のみを表示する
-w：単語数（スペースやタブで区切られた数）のみを表示する
-c：バイト数のみを表示する
## ファイルを1つだけ指定する場合、複数のファイルを指定する場合の両方に対応する
## ruby ls.rb | ruby wc.rb
## 本物の wc コマンドはノーブレークスペースを含むマルチバイト文字を1単語多くカウントするが、自作の wc コマンドでは対応しなくても良い。
## 特殊な入力ケースに対応する必要はありません(例: 単語の区切りの空白文字は半角スペース、タブ、改行程度で大丈夫です
=end

l_option = false
w_option = false
c_option = false
default = [l_option, w_option, c_option].none?

lines = 5
words = 200
bytes = 500
file = 'wc.rb'

# 出力する要素を選ぶ
counts = []
counts << lines.to_s if l_option || default
counts << words.to_s if w_option || default
counts << bytes.to_s if c_option || default

# 最大桁数で右揃え処理
def pad(counts)
  max = counts.map do |count|
    count.length
  end.max
  counts.map do |count|
    count.rjust(max)
  end
end

# 出力項目をまとめる
padded_counts = pad(counts)
row = [*padded_counts, file]
# 区切り文字は半角スペース
puts row.join(' ')

require 'minitest/autorun'
class WCTest < Minitest::Test
  def test_output
    l_option = false
    w_option = true
    c_option = false
    default = [l_option, w_option, c_option].none?

    lines = 5
    words = 200
    bytes = 500
    file = 'wc.rb'

    # 出力する要素を選ぶ
    counts = []
    counts << lines.to_s if l_option || default
    counts << words.to_s if w_option || default
    counts << bytes.to_s if c_option || default
    padded_counts = pad(counts)
    row = [*padded_counts, file]
    assert_equal '200 wc.rb', row.join(' ')
  end
end
