
## レビュー者の方へ

前回のフィードバック大変ありがとうございました。  
どの内容も分かりやすく、あそこまで丁寧に見て頂けると思っていなかったのでとても感動しました。  
ゆめみさんのエンジニアの方達のレベルの高さと優しい雰囲気を感じ取れて、友人にも勧めたくなる良い会社だと思わされました。  

今回の再挑戦ですが正直フィードバックの対応で精一杯でアプリのクオリティはあまり上げれませんでした。  
ですが、全力で取り組み楽しんで行いました。読みづらい個所も多々あると思いますが宜しくお願い致します。  
<br>

## 前回からの変更点  
・前回頂いたフィードバックをほぼ全て対応(完)  
・ダークモード対応  
・デバイスの回転の対応  
・正確なソート順序でデータの取得( GitHub APIから sort, orderのパラメータでリクエスト)  
・GitHubのWebサイトへ遷移 (Safari)  

他にもデータ管理やファイルの切り分けなどいろいろ変更しております。  
<br>
## 出来なかったこと  
・テストコード  

すいません。  
自分の知識不足でテストコードは対応できませんでした。  
今後また学習して参ります。  
<br>
## 今回挑戦したこと  
・Git・GitHub  

前回、Gitをまったく扱えてなかったので再学習してきました。  
① Gitのコマンドを調べアウトプット。CUIで叩けるよう練習。  
② Git-flow を１から勉強し実践的に行ってみました。  
<br>
Git-flow  
<img width="1276" alt="スクリーンショット 2023-05-25 4 32 24" src="https://github.com/Loco-tequila0724/GitHubSearchApp/assets/77542296/506cb142-7c70-4343-b004-786a876baf95">  
<img width="600" alt="スクリーンショット 2023-05-25 4 32 00" src="https://github.com/Loco-tequila0724/GitHubSearchApp/assets/77542296/833a6e3e-ab99-4fbb-b1e6-5f6d0276f868">  
<br>
Git コマンド  
<img width="1663" alt="スクリーンショット 2023-05-25 4 37 28" src="https://github.com/Loco-tequila0724/GitHubSearchApp/assets/77542296/fad18e74-078d-4431-886c-f9fa204a737f">  
<br>
<br>
<br>

### これより下は前回の文章から変更してませんので読まなくても大丈夫です。
<br>
<br>
<br>

# 株式会社ゆめみ iOS エンジニアコードチェック課題

## 概要

新機能やUIのブラッシュアップも行い、指定された課題にすべて取り組みました。  

問題を１件追加で書いてます。(解決済)  
[Issues](https://github.com/Loco-tequila0724/GitHubSearchApp/issues/12) リンク
<br>
## アプリ仕様

アプリ名『 GitRepo Find 』  
GitHubのリポジトリを検索するアプリです。
<br>
### 環境

- IDE：Xcode 14.3 
- Swift: 5.8 
- 開発ターゲット： iOS 15.0
- ライブラリの利用： 無し
- 設計: VIPERアーキテクチャ
- UIKit/ストーリーボードのみ SwiftUI未使用
<br>
### 細かな設定

・iPad非対応  
・ダークモード非対応  
・画面の回転不可 (縦画面で固定)  
・ステータスバー lightモードで固定  
・ローカライズ(未)  
・SwiftLint 導入  
<br>
### アプリ画面
<img width="332" alt="スクリーンショット 2023-05-01 18 35 46" src="https://user-images.githubusercontent.com/77542296/235435791-f7c50d8d-498c-42d4-8b9c-8272acdab904.png" width="400">  
<img width="353" alt="スクリーンショット 2023-05-01 17 10 08" src="https://user-images.githubusercontent.com/77542296/235435644-4100ae92-1a59-4f33-870d-d0dcbd5eaa25.png" width="400">    
<br>
## 取り組んだ課題
・すべての課題を対応(済)
<br>
## アプリ名・アプリのアイコンを自作
フリー素材『icooon mono』  
作図 ツール『Cacoo(カクー)』

<img width="314" alt="スクリーンショット 2023-05-02 3 32 01" src="https://user-images.githubusercontent.com/77542296/235507544-8ef388aa-015d-4ad9-8701-14f50fc2f2ff.png" width="230">

[アイコンのリンク①](https://icooon-mono.com/14925-%e7%81%ab%e6%98%9f%e4%ba%ba%e3%82%a2%e3%82%a4%e3%82%b3%e3%83%b33/)  
[アイコンのリンク②](https://icooon-mono.com/00039-%e6%a4%9c%e7%b4%a2%e7%94%a8%e3%81%ae%e8%99%ab%e7%9c%bc%e9%8f%a1%e3%82%a2%e3%82%a4%e3%82%b3%e3%83%b3%e7%b4%a0%e6%9d%90/)  
[アイコンのライセンスリンク](https://icooon-mono.com/license/) 確認(済)  
<br>
## UIをブラッシュアップ
・カスタムセル使用、画像とstar数の表示  
・ナビゲーションバーの色とタイトル指定  
・データローディング表示  
・API通信。ユーザーへエラーの表示  
・サーチバーのテキストが空になったらテーブルビューをリセット  
<br>
## 新機能
### 検索結果順序ソート機能
テーブルビューの順序を降順・昇順に並び替えるボタンを実装  
リポジトリのStarの数で判定してソートしてます。

実装した理由
人気なものや有名なものから情報を得たいユーザーは多い(情報の信用度が高いから)、    
ランダムな順番で表示されているよりも、ユーザーがすぐ確認しやすいようソート機能があれば便利。    
と考え実装しました。
<br>
## アピールポイント・挑戦したこと

### テーブルビューが滑らかに動く

画像のカクつきやチラつきなど防止するため細かく設定しました。  
・非同期で画像の取得と生成  
・画像をリサイズし容量を下げた  
・画像キャッシュの使用  
・タスクのキャンセル  
<br>
### VIPERアーキテクチャの適用

最近VIPERアーキテクチャを学習したので、新しく学んだことをさっそく実践で使用しました。  
いろんな技術をどんどん試していこうという意欲があります。  
[学習内容リンク](https://www.notion.so/VIPER-45727e3a383f4e98b4416ca19a0cd9a2)  

<img width="1253" alt="スクリーンショット 2023-05-01 17 18 51" src="https://user-images.githubusercontent.com/77542296/235435028-00bbf6b9-a496-4c5c-a685-4fe49ccc07d4.png" width="600">  

