PyukiWiki - 自由にページを追加・削除・編集できるWebページ構築CGI

	"PyukiWiki" version 0.1.7-rc3 $$
	Copyright (C)
	  2005-2006 PukiWiki Developers Team
	  2004-2006 Nekyo (Based on PukiWiki, YukiWiki)
	License: GPL version 2 or (at your option) any later version
			and/or Artistic version 1 or later version.
	Based on YukiWiki http://www.hyuki.com/yukiwiki/ and PukiWiki

	URL:
	http://nekyo.hp.infoseek.co.jp/
	http://pyukiwiki.sourceforge.jp/

	MAIL:
		Nekyo <nekyo (at) yamaneko (dot) club (dot) ne (dot) jp>
		ななみ <nanami (at) daiba (dot) cx> (注：ネカマです)

	$Id: README.txt,v 1.66 2006/09/29 09:11:31 papu Exp $

	このテキストファイルはShift-JIS、TAB4で記述されています。

-------------------------------------------------
■最新情報
-------------------------------------------------
以下のURLで最新情報を入手してください。
http://nekyo.hp.infoseek.co.jp/
http://pyukiwiki.sourceforge.jp/

-------------------------------------------------
■導入前の注意
-------------------------------------------------
アクセスカウンターの不具合を修正しているため、以前のカウンターが正しく
修正できない可能性があります。
Totalの数字のみ自動修正を自動的に試みますが、すべてのカウンターの数値を
修正する場合は、以下のカウンタデータ変換ツールを使用して下さい。

・Birth of Re-Birth:【不具合対策】カウンタデータ変換ツール
　http://www.re-birth.com/pyuki/wiki.cgi?%a5%b5%a5%a4%a5%c8%c0%a9%ba%ee%2fPyukiWiki%2f%c9%d4%b6%f1%b9%e7#i3

-------------------------------------------------
■概要
-------------------------------------------------
PyukiWiki（ぴゅきうぃき）はハイパーテキストを素早く容易に追加・編集・削除できる
Webアプリケーション(WikiWikiWeb)です。テキストデータからHTMLを生成することがで
き、Webブラウザーから何度でも修正することができます。

PyukiWikiはperl言語で書かれたスクリプトなので、多くのCGI動作可能なWebサーバー
（無料含む）に容易に設置でき、軽快に動作します。

-------------------------------------------------
■ライセンス
-------------------------------------------------
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

>このプログラムはフリーソフトウェアです。それを再配布し、かつ、
>またはPerl自体と同じ条件の下でそれを修正することができます。

PyukiWikiは、GPL2もしくはArtisticライセンスの元で配布されます。
自由に利用し、自由に配布し、自由に改造し、それを再配布して構いません。
ただし、原版と同名のパッケージとして名乗ることを禁止します。
詳しくは、下記のURLをご覧下さい。

・PyukiWiki:ライセンスについて
　http://pyukiwiki.sourceforge.jp/cgi-bin/w/PyukiWiki/Install/License/

・GNU GPL
　http://www.gnu.org/copyleft/gpl.html

・GNU GPLの日本語版
　http://www.opensource.jp/gpl/gpl.ja.html

・The Artistic License 1.0
　http://www.perl.com/language/misc/Artistic.html

・The Artistic License 日本語訳
　http://www.opensource.jp/artistic/ja/Artistic-ja.html

・参考　Perl6's License Should be (GPL|Artistic-2.0)
　http://dev.perl.org/perl6/rfc/346.html

-------------------------------------------------
■動作環境
-------------------------------------------------
PyukiWikiの動作環境は以下のとおりです。

・full版はインストール時に1.5Mバイト、compact版は
　インストール時に1Mバイト必要です。

・compact版は、以下のモジュールがサーバーにインストール
　されている必要があります。
　Jcode.pm、Time::Local

・CGIの動作し、Perl5.005_004以降が動作するWebサーバー
　奨励はPerl5.8.1以降です。

-------------------------------------------------
■パッケージについて
-------------------------------------------------
・-full
　通常はこちらをインストールします。

・-compact
　サーバーの容量が少ない場合、こちらを導入してみて下さい。
　以下の制限があります。
　・opml,あいまい検索,sitemap,showrss,bugtrack,perlpod,settingがない
　・管理プラグイン(listfrozen,server,servererror,versionlist)がない
　・PukiWiki互換ダミープラグインがない
　・Explugin lang, setting, urlhack, punyurlがない
　・添付ファイルは一部の圧縮ファイル、画像以外できません。
　・英語関係ファイルがない
　・Jcode.pm、Time::Localがサーバーにインストールされている必要がある

・-update-full, -update-compact
　アップデート用のファイルです。
　初期wiki、及び .htaccess ファイルがありません。

・-devel
　PyukiWikiプラグイン、及びコア開発に必要なツールが
　揃っています。ドキュメントのpodが付属しています。

-------------------------------------------------
■はじめに
-------------------------------------------------
(1) index.cgiの一行目をあなたのサーバに合わせて修正します。

	#!/usr/local/bin/perl
	#!/usr/bin/perl
	#!/opt/bin/perl
	等

(2) pyukiwiki.ini.cgi の変数の値を修正します。

(3)「ファイル一覧」にあるファイルをサーバに転送します。
    転送モードやパーミッションを適切に設定します。

(4) ブラウザでサーバ上の index.cgiのURLにアクセスします。

-------------------------------------------------
■ファイル一覧
-------------------------------------------------

●説明文

以下のファイルは、
Webサーバに転送する必要はありません。

+-- README.txt			解説文書（このファイル）
+-- COPYRIGHT.txt		GNU GENERAL PUBLIC LICENSE(原文）
+-- COPYRIGHT.ja.txt	GNU GENERAL PUBLIC LICENSE(日本語訳）

●CGI群

以下のファイルはCGIが実行できるディレクトリにFTPします。

 * と記載されているファイルは、コンパクト版にはありません。

                       転送モード パーミッション   説明
+-- index.cgi               TEXT  755 (rwxr-xr-x)  CGIwrapper
+-- pyukiwiki.ini.cgi       TEXT  644 (rw-r--r--)  定義ファイル
+-- lib                           755 (rwxr-xr-x)  使用モジュール群
    +-- wiki.cgi            TEXT  644 (rw-r--r--)  CGI本体
    +-- antispam.inc.pl     TEXT  644 (rw-r--r--)  Exプラグイン
    +-- authadmin_..inc.pl  TEXT  644 (rw-r--r--)  Exプラグイン
    +-- autometa....inc.pl  TEXT  644 (rw-r--r--)  Exプラグイン
    +-- gzip.inc.pl         TEXT  644 (rw-r--r--)  Exプラグイン
    +-- lang.inc.pl*        TEXT  644 (rw-r--r--)  Exプラグイン
    +-- punyurl.inc.pl*     TEXT  644 (rw-r--r--)  Exプラグイン
    +-- setting.inc.pl*     TEXT  644 (rw-r--r--)  Exプラグイン
    +-- slashpage.inc.pl*   TEXT  644 (rw-r--r--)  Exプラグイン
    +-- urlhack.inc.pl*     TEXT  644 (rw-r--r--)  Exプラグイン
    +-- Algorithm                 755 (rwxr-xr-x)  ディレクトリ
    |   +-- Diff.pm         TEXT  644 (rw-r--r--)  差分用
    +-- Digest*                   755 (rwxr-xr-x)  ディレクトリ
    |   +-- Perl*                 755 (rwxr-xr-x)  ディレクトリ
    |       +-- MD5.pm*     TEXT  644 (rw-r--r--)  md5 計算用
    +-- File                      755 (rwxr-xr-x)  ディレクトリ
    |   +-- MMagic.pm       TEXT  644 (rw-r--r--)  ファイル種別監査用
    |   +-- magic.txt*      TEXT  644 (rw-r--r--)  Magicファイル（リリース版のみ）
    |   +-- magic_compa..** TEXT  644 (rw-r--r--)  Magicファイル（コンパクト版のみ）
    +-- Time                      755 (rwxr-wr-x)  ディレクトリ 
    |   +-- Local.pm        TEXT  644 (rw-r--r--)  recent.inc.plで使用
    +-- IDNA*                     755 (rwxr-wr-x)  ディレクトリ 
    |   +-- Punycode.pm*    TEXT  644 (rw-r--r--)  recent.inc.plで使用
    +-- Jcode*                    755 (rwxr-wr-x)  ディレクトリ 
    |   +-- Unicode*              755 (rwxr-wr-x)  ディレクトリ
    |   |   +-- Contants.pm*TEXT  644 (rw-r--r--)  Jcode.pm で使用
    |   |   +-- NoXS.pm*    TEXT  644 (rw-r--r--)  Jcode.pm で使用
    |   +-- _Classic.pm*    TEXT  644 (rw-r--r--)  Jcode.pm で使用
    |   +-- Contants.pm*    TEXT  644 (rw-r--r--)  Jcode.pm で使用
    |   +-- H2Z.pm*         TEXT  644 (rw-r--r--)  Jcode.pm で使用
    |   +-- Tr.pm*          TEXT  644 (rw-r--r--)  Jcode.pm で使用
    |   +-- Unicode.pm*     TEXT  644 (rw-r--r--)  Jcode.pm で使用
    +-- Nana                      755 (rwxr-xr-x)  ディレクトリ
    |   |-- Cache.pm        TEXT  644 (rw-r--r--)  キャッシュモジュール
    |   |-- Lock.pm         TEXT  644 (rw-r--r--)  ファイルロック用
    |   |-- OPML.pm*        TEXT  644 (rw-r--r--)  OPMLモジュール
    |   |-- Pod2Wiki.pm*    TEXT  644 (rw-r--r--)  pod→wiki変換モジュール
    |   |-- Search.pm*      TEXT  644 (rw-r--r--)  あいまい検索用
    |   +-- YukiWikiDB.pm   TEXT  644 (rw-r--r--)  リニューアルしたYukiWikiDB
    +-- Yuki                      755 (rwxr-xr-x)  ディレクトリ
        +-- DiffText.pm     TEXT  644 (rw-r--r--)  差分用
        +-- RSS.pm          TEXT  644 (rw-r--r--)  RSS用
        +-- YukiWikiDB.pm   TEXT  644 (rw-r--r--)  オリジナルのYukiWikiDB

●参照ファイル

以下のファイルは、
pyukiwiki.ini.cgi 内の変数 $::data_homeで指定するディレクトリに転送します。
詳しくは pyukiwiki.ini.cgi を参照して下さい。

+-- counter                       777 (rwxrwxrwx)  カウンタ値保存用ディレクトリ
|   +-- index.html          TEXT  755 (rwxr-xr-x)  一覧表示防止用
+-- diff                          777 (rwxrwxrwx)  差分保存用ディレクトリ
|   +-- index.html          TEXT  755 (rwxr-xr-x)  一覧表示防止用
+-- info                          777 (rwxrwxrwx)  情報保存用ディレクトリ
|   +-- index.html          TEXT  755 (rwxr-xr-x)  一覧表示防止用
+-- plugin                        777 (rwxrwxrwx)  プラグイン用ディレクトリ
|   +-- index.html          TEXT  755 (rwxr-xr-x)  一覧表示防止用
+-- resource                      755 (rwxr-xr-x)  リソース用ディレクトリ
|   +-- index.html          TEXT  755 (rwxr-xr-x)  一覧表示防止用
|   +-- すべてのファイル    TEXT  644 (rw-r--r--)  リソースファイル
|   +-- conflict.ja.txt     TEXT  644 (rw-r--r--)  更新の衝突時のテキスト
+-- wiki                          777 (rwxrwxrwx)  ページデータ保存用ディレクトリ
    +-- index.html          TEXT  755 (rwxr-xr-x)  一覧表示防止用


以下のファイルは、
pyukiwiki.ini.cgi 内の変数 $::data_pubで指定するディレクトリに転送します。
詳しくは pyukiwiki.ini.cgi を参照して下さい。


                       転送モード パーミッション   説明
+-- attach                        777 (rwxrwxrwx)  添付保存用ディレクトリ
|   +-- index.html          TEXT  755 (rwxr-xr-x)  一覧表示防止用
+-- cache                         777 (rwxrwxrwx)  一時ディレクトリ
|   +-- index.html          TEXT  755 (rwxr-xr-x)  一覧表示防止用
+-- image                         755 (rwxr-xr-x)  画像保存用ディレクトリ
|   +-- index.html          TEXT  755 (rwxr-xr-x)  一覧表示防止用
+-- skin                          755 (rwxr-xr-x)  スキン用ディレクトリ
    +-- pyukiwiki.skin.ja.cgi     644 (rw-r--r--)  スキンファイル
    +-- default.ja.css            644 (rw-r--r--)  表示用 css
    +-- print.ja.css              644 (rw-r--r--)  印刷用 css
    +-- blosxom.css               644 (rw-r--r--)  blosxom 用 css
    +-- instag.js                 644 (rw-r--r--)  拡張編集用 JavaScript
    +-- common.ja.js              644 (rw-r--r--)  共通使用JavaScript
    +-- index.html                644 (rw-r--r--)  一覧表示防止用

●パーミッション設定のTIPS
一部ユーザー権限で動作するWebサーバーの場合、「とりあえず」
index.cgiのパーミッションを 701 (rwx-----x) にすることで動作します。
その他、セキュリティーを強化したい場合は、各ディレクトリを以下のように
設定します。

+-- attach                        701 (rwx-----x)  添付保存用ディレクトリ
+-- cache                         701 (rwx-----x)  一時ディレクトリ
+-- counter                       700 (rwx------)  カウンタ値保存用ディレクトリ
+-- diff                          700 (rwx------)  差分保存用ディレクトリ
+-- image                         701 (rwx-----x)  画像保存用ディレクトリ
+-- info                          700 (rwx------)  情報保存用ディレクトリ
+-- lib                           700 (rwx------)  使用モジュール群
+-- plugin                        700 (rwx------)  プラグイン用ディレクトリ
+-- resource                      700 (rwx------)  リソース用ディレクトリ
+-- skin                          701 (rwx-----x)  スキン用ディレクトリ
+-- wiki                          700 (rwx------)  ページデータ保存用ディレクトリ

-------------------------------------------------
■もし動かなければ？
-------------------------------------------------
・パーミッションが正しいかどうか確認して下さい。
　プロバイダ奨励のパーミッションをなるだけ優先して下さい。

・それでもだめなら.htaccessをまず削除してみて下さい。
　特に、attach/.htaccess, image/.htaccess, skin/.htaccessの削除を忘れないで下さい。

・一部のプロバイダーでは、設定に工夫が必要です。

・もしかしたら、OSがWindows系の場合がありますので、適切な設定をして下さい。

・Digest::MD5が導入されていないサーバーでは、以下のように変更して下さい。
　attach.inc.plのuse Digest::MD5 qw(md5_hex);をコメントアウトし、
　#use Digest::Perl::MD5 qw(md5_hex);のコメントをはずす

・CGI.pmが導入されていないサーバーでは、別途配布されているCGI.pm.zipを解凍して
　lib 以下に置いて下さい。
　http://pyukiwiki.sourceforge.jp/cgi-bin/w/PyukiWiki/Download からダウンロードできます。

・utf8にしたら文字化けする？PukiWiki宛てのInterWikiが正常ではない？
　perl5.8.0以前のバージョンでかつサーバー上にJcodeがインストールされていません。
　代替のJcode.pm 0.88をインストールして下さい。
　http://pyukiwiki.sourceforge.jp/cgi-bin/w/PyukiWiki/Download からダウンロードできます。

-------------------------------------------------
■簡単なFAQ
-------------------------------------------------
・PyukiWikiの作者が変ったのですか？
　いいえ、変ったのではなく追加です。

・既存のプラグインが動かなくなってしまったのですが？
　可能な限り、過去バージョン向けのプラグインを動作できるよう変更はしていますが、
　実質、0.1.6にて大幅に仕様が変更になり動作しなくなったものもあります。
　(popular, rename等は、既存バージョン用のプラグインが「まともに」（＝ちょっとしたこと
　　でも）動作しないので、新しいバージョンを添付しています）

・mod_perl、speedy_cgiで動かないのですが？
　対応させるためのルーチンは存在するのですが、今回のバージョンでは見送りとします。

・wiki.cgiが醜い(本来の変換は見にくい）のですが・・・
　-full版、-compact版は、実際に動作する環境の為に、余計なコメント等を
　大幅に削除しています。
　また、ベンチマークを取得して、ある程度サブルーチンの順番も考慮しています。
　そのため、0.1.5から比べて見にくいソースになっています。
　wiki.cgiのサブルーチンのコメントが必要な方は、-devel版をダウンロードして下さい。
　同一のバージョンであれば、-full版と-devel版であれば、混在しても動作します。

・ライセンスがかわったのですか？
　「you can redistribute it and/or modify it under the same terms as Perl itself.」
　「＝Perlと同じライセンスで再配布できます。」
　の文面を明確にすると、GPL2とArtisticライセンスが適用されることになります。
　SourceForge.jpプロジェクト登録のため、ライセンスをはっきりさせるために
　明記したのであり、基本的にはYukiWikiからのライセンスを継承しているものと考えています。

・PyukiWiki0.1.5のwikiをそのまま移行すると文面がおかしくなるのですが？
　多くのPukiWiki文法を取り入れると同時に、多くの文法不具合も修正されています。
　仕様外の文法で記述されている場合、不具合が生じることがあります。
　また、インラインプラグイン(&plugin(...);)において、「;」で終了していないと、
　不具合が起きます。ネスト可能にする為に厳格に文法チェックを行なっていますので、
　閉じていない場合は、「；」で閉じるようにして下さい。

-------------------------------------------------
■0.1.5からの主な変更点
-------------------------------------------------
・多くのPukiWiki文法を取り入れました。
　PukiWikiとの互換性がいっそう高くなり、表現力が高くなります。

・wiki.cgi起動と同時に動的に読み込む expluginを搭載しました。
　内部の関数をハック（乗っ取り）し、別の動作をさせることができます。
　(overloadモジュールを使用していません）

・システムメッセージ対応
　スキン(sub skin)に渡される ページ名($page)に、以下のような仕様変更があります。
　ページ名は、タブ区切りで、以下のような内容となります。
　"ページ名(空白のこともあり)" \t "システムメッセージ" \t "エラーメッセージ"

・スキンで、printをせず、変数に格納することとなりました。
　そのため、既存のスキンはそのままではご利用になれません。
　$htmlbody 等の変数に一括して格納し、最後に return する必要があります。

・半角スペースを含むページが作成可能になりました
　ただし、先頭・最後に半角スペースがあるページは作れません

・[[[うぃき]]] のようなブラケットをしたときに出たバグを修正しました。

・部分編集に対応しました。
　巨大なページでも、編集しやすくなりました。

・検索エンジンSEO対策をしました。
　・URLから「?」等を省く、urlhack.inc.cgiプラグインの追加
　・編集画面等では、ロボットがクロールしないようにMETAタグを設定した

・nph CGIに対応しました。
　ファイル名の先頭を nph- にすると、直接HTTP/1.1 200 OK から出力します。

・$::IN_HEAD、$::HTTP_HEADER変数に代入すると、それぞれ、<head>タグ内、
　HTTPヘッダに代入されるようになった。

・xhtmlに対応しました。
　デフォルトでは HTML 4.01 Transitionalで出力されますが、以下を選択することが
　できます。
　・XHTML 1.1
　・XHTML 1.0 Strict (非正式対応)
　・XHTML 1.0 Transitional (非正式対応)
　・XHTML Basic 1.0 (非正式対応)

・_action のリターン値に以下を追加
　・http_header
　・header
　・ispage
　・notviewmenu

・WikiNameを廃止することができるようになりました。

・スキンで表示せず、内部でバッファリングするようにした。

・スキンの最も下のCopyrightのフッタをwiki文法に変更した

・htmlディレクトリとcgi-binディレクトリが異なるシステムで、従来より
　設置しやすくしました。

・リソースを分割して、プラグイン実行時に動的に読み込むようにした

・pagenavi.inc.pl
　PyukiWIki/Download>0.1.6 をそれぞれに、リンクしたい時に
　便利なプラグインです。
　, 区切りで、Wiki文法で入力しますが、 / を含む場合は
　ページ名だけを入力します。
　#pagenavi(*,PyukiWIki/Download>0.1.6,''ダウンロード'') 等

・server.inc.pl
　（wikiで使うようなものではないのですが・・・）
　サーバー情報を詳細に表示するプラグインです。
　実行は、?cmd=server のみで、凍結パスワードが必要になります。

・servererror.inc.pl
　.htaccessでの、ErrorDocumentから呼び出すサーバーエラー表示
　プラグインです。

・sitemap.inc.pl
　以前公開していたものを、バグフィックスして標準化しました

・deletecache.inc.pl
　管理者用プラグインで、キャッシュディレクトリの中身をすべて削除します。
　OPML取得に必要な外部サイト情報も消去されますので、RSSを取得している
　外部サイトを表示しているページを再表示する等して、再構築をするように
　して下さい。

・article.inc.pl
　改行自動変換を実装（変数フラグのみあった）
　名前なし、サブジェクトなし投稿を禁じるフラグをつけた
　ページが凍結されていても投稿できるようにもなった。

・attach.inc.pl
　多くの既存バグを修正
　nph CGIに対応
　アップロードは自由だが、削除はパスワードが必要なモードを加えた

・comment.inc.pl
　ページが凍結されていても投稿できるようにもなった。

・counter.inc.pl
　新形式のカウンターに対応（1年分保存可能です。設定が必要です）
　旧形式のカウンターのバグを自動修正する機能をもたせた
　昨日以前を昨日と認識するバグを修正
　MenuBar等にカウンターを置いた時の処理変更

・edit.inc.pl
　PukiWikiライクな編集画面になるようになった。
　既存ページから、雛形として読み込む機能を追加

・lookup.inc.pl
　InterWikiName正規化に伴い変更 
　$::usepopup変数に対応 
　nph CGIに対応

・newpage.inc.pl
　ページのprefixを選択できるようになった。

・recent.inc.pl
　半角スペースを含むページに対応

・rss10.inc.pl
　半角スペースを含むページに対応
　nph CGIに対応

・search.inc.pl
　search_fuzzy.inc.pl追加に伴う変更 

・search_fuzzy.inc.pl
　日本語あいまい検索用です。
　モジュールをuseしているので別のモジュールになっています。直接呼出しはできません

・showrss.inc.pl
　PyukiWikiのRSSが正しく取得できなかったのを修正

・ref.inc.pl
　いくつかのバグを修正
　$::usepopup変数に対応

・その他プラグイン
　いくつかの、PukiWiki内部制御用のコマンドを、ダミープラグインとして
　実装しています。

・サンプル
　CGIを外部から呼び出せない等の理由で、外部からInterWikiできないwikiのために、
　PHPやHTML+JavaScriptのwrapperをサンプルとして添付しました。 

-------------------------------------------------
■使用しているライブラリ等
-------------------------------------------------

・YukiWikiDB関連　結城浩氏、極悪氏
　http://www.hyuki.com/yukiwiki/wiki.cgi?YukiWikiDB2
　http://www.hyuki.com/yukiwiki/wiki.cgi?YukiWikiDB%a4%ce%a5%ed%a5%c3%a5%af%b5%a1%c7%bd
　http://www.hyuki.com/yukiwiki/wiki.cgi?YukiWikiLock

・RSS.pm、Difftext.pm
　http://www.hyuki.com/yukiwiki/

・Algorithm::Diff
　http://search.cpan.org/~tyemq/

・File::MMagic
　http://search.cpan.org/~knok/
　なお、MMagic.pm内臓のmagicデータは、データ判別においての材料が不足している為
　削除してあります。

・Time::Local
　http://search.cpan.org/~drolsky/

・Digest::Perl::MD5
　http://search.cpan.org/~delta/

・Jcode.pm
　http://openlab.jp/Jcode/index-j.html
　http://search.cpan.org/~dankogai/

・IDNA::Punycode
　http://search.cpan.org/~roburban/

・迷惑メール収集業者対策＠Toshi (NINJA104)
　http://ninja.index.ne.jp/~toshi/soft/untispam.shtml

・ppblog
　http://p2b.jp/
　多くの有用なJavaScriptを利用させて頂いています。
　・FireFoxのツールチップ改造＠martin
　　http://martin.p2b.jp/index.php?date=20050201
　・ブラウザ内での画像ポップアップ
　　http://martin.p2b.jp/index.php?UID=1115484023

・Perlメモより＠大崎 博基氏
　http://www.din.or.jp/~ohzaki/perl.htm
　http://www.din.or.jp/~ohzaki/regex.htm
　・URL及びメールアドレスの正規表現
　・年月日から曜日を取得する
　・年月から末日を取得する
　・第Ｎ　Ｗ曜日ｎ日付を求める
　・EUC文字関係の処理
　・リネームロック
　・改行コードを統一する

-------------------------------------------------
■謝辞
-------------------------------------------------
・本家のWikiを作ったWard Cunninghamに感謝します。
　http://c2.com/cgi/wiki

・PyukiWikiを楽しんで使ってくださるみなさんに感謝します。

・PukiWiki、YukiWiki等多くのWikiクローンの作者さんたちに感謝します。

・YukiWiki
　http://www.hyuki.com/yukiwiki/
　PyukiWikiのベースとして、YukiWikiはなくてはならないものでした。

・PukiWiki (PHP)
　http://pukiwiki.sourceforge.jp/
　デザインをはじめ、多くの書式等を参考にしました。

・PukiWiki Plus! (PHP)
　http://pukiwiki.cafelounge.net/plus/
　国際化の実装方法のアイデア、国アイコンの公開に感謝します。

・「極悪」さんのwiki (Perl)
　http://hpcgi1.nifty.com/dune/gwiki.pl
　特に、YukiWikiDBに感謝します。

・塚本牧生さんのWalWiki (Perl)
　http://digit.que.ne.jp/work/
　テーブル機能、部分編集機能に感謝します。

・その他、パッチを提供して頂いた以下の方に感謝します。
　Mr koizumi, wadldw, pochi

-------------------------------------------------
■作者
-------------------------------------------------
Copyright (C) 2004-2006 by Nekyo
http://nekyo.hp.infoseek.co.jp/

Copyright (C) 2002-2006 by Hiroshi Yuki
http://www.hyuki.com/

Copyright (C) 2005-2006 by ななみ
http://lineage.netgamers.jp/ http://line.daiba.cx/

Copyright (C) 2004-2006 by やしがにもどき
http://hpcgi1.nifty.com/it2f/wikinger/pyukiwiki.cgi

Copyright (C) 2005-2006 by Junichi
http://www.re-birth.com/

Copyright (C) 2005-2006 PukiWiki Developers Team
http://pyukiwiki.sourceforge.jp/
