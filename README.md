# powershell-scripts / readme.md

文書作成日:西暦2023年7月10日 最終更新日:西暦2023年9月8日

日本語:
このリポジトリは「Power Shell」の自作スクリプトを保存しています。このスクリプトが誰かの役に立てば幸いと思い、リポジトリを公開しています。各スクリプトの解説は以下の通りです。

English:
This repository is the storage preserving my scripts of "Power Shell". I publicing this repository because I am happy if my scripts help someone. There are explanation of each scripts at below.

1. audio/
    1. [encode-to-opus.ps1](#encode-to-opusps1)
    2. [normalize.ps1](#normalizeps1)
    3. [set-title-from-filename.ps1](#set-title-from-filenameps1)
    4. [set-track-number.ps1](#set-track-numberps1)
2. video/
    1. [hevc-qp-encode.ps1](#hevc-qp-encodeps1)
    2. [thumbail.ps1](#thumbailps1)


## audio

### encode-to-opus.ps1
必要環境(Required): ffmpeg ver.6.0

現在のディレクトリにおいて、特定の拡張子を持つすべての音声ファイルのラウドネス値を取得し、音声のラウドネス値の正規化とノイズを除去する。また音声ファイルをビットレートが192kのopusに変換する。opusファイルは現在のディレクトリに生成される。引数は対象にしたいファイルの拡張子。

Get loudness value of all audio file having certain filename extension on current directory, then normalize and remove the noise from these. And convert audio file to "opus" that the bitrate is 160k. opus file is generated at current directory.The parameter is the filename extension that want to target.

```
> &"$env:USERPROFILE\audio\encode-to-opus.ps1" flac
```

### normalize.ps1
必要環境(Required): ffmpeg ver.6.0

現在のディレクトリにおいて、特定の拡張子を持つすべての音声ファイルのラウドネス値を取得し、音声のラウドネス値の正規化とノイズを除去する。ラウドネス値が正規化された音声ファイルは、現在のディレクトリの下に作成される「normalized」というディレクトリに保存される。引数は対象にしたいファイルの拡張子。

Get loudness value of all audio file having certain filename extension on current directory, then normalize and remove the noise from these. Normalized audio file is generated at a directory:"normalized". The parameter is the filename extension that want to target.

```
> &"$env:USERPROFILE\audio\normalize.ps1" flac
```

### set-title-from-filename.ps1
必要環境(Required): ffmpeg ver.6.0

現在のディレクトリにおいて、特定の拡張子を持つすべての音声ファイルを対象として、ファイル名から拡張子を除いた文字列をメタデータのtitleに設定する。titleが変更されたファイルは現在のディレクトリの下に作成される「titled」というディレクトリに保存される。引数は対象にしたいファイルの拡張子。

Set the filename excluding the filename extension to "title" in the metadata for all audio file having certain filename extension as target on current directory. An audio file modified title is generated at a directory:"titled". The parameter is the filename extension that want to target.

```
> &"$env:USERPROFILE\audio\set-title-from-filename.ps1" mp3
```

### set-track-number.ps1
必要環境(Required): ffmpeg ver.6.0

現在のディレクトリにおいて、特定の拡張子を持つすべての音声ファイルを対象として、取得した順にメタデータのtrackに番号を付与する。trackに番号が付与された音声ファイルは現在のディレクトリの下に作成される「numbered」というディレクトリに保存される。第一引数は対象にしたいファイルの拡張子、第二引数は付加する最初の番号。

Add number to "track" in metadata by obtained order for all audio file having certain filename extension as target on current directory. An audio file added number to "track" is generated at a directory:"numbered". First parameter is the filename extension that want to target, second parameter is initial number that we want to add.

```
> &"$env:USERPROFILE\audio\set-track-number.ps1" mp3
```


## video

### hevc-qp-encode.ps1
必要環境(Required): ffmpeg ver.6.0

動画のラウドネス値を取得し、音声のラウドネス値の正規化とノイズを除去、さらに映像をHEVCでエンコードする。NVENCを用いるのでGeForceシリーズのGPUが必要。引数はエンコードを行いたい動画ファイルのパス、Iフレームの品質を表す整数値、Pフレームの品質を表す整数値。現在のディレクトリでスクリプトを実行するなら拡張子を含むファイル名だけでよい。

Get loudness value of video file on current directory, then normalize and remove the noise from it. And encode video to HEVC. This need GPU of GeForce series because use NVENC. The parameters are a path of video file that want to encode, an integer presenting quality of I frame and an integer presenting quality of P frame. It is filename contained the filename extension only if run a script in current directory.

```
> &"$env:USERPROFILE\video\hevc-qp-encode.ps1" 2023-07-06_23-52-32.mp4
```

### thumbail.ps1
必要環境(Required): ffmpeg ver.6.0

動画の特定の時間から、4フレーム毎にその場面の画像を30枚生成する。画像は現在のディレクトリにある「ss」というディレクトリに保存される。第一引数は対象にする動画ファイル、第二引数は開始位置に指定する時間、第三引数は画像の形式。

Generate 12 images of scene by 5 frames form specific time of video. Image saved at "ss" directory under current directory. First parameter is a target video file, second parameter is time specifying start point, third parameter is type of image.

```
&"$env:USERPROFILE\Documents\Github\powershell-scripts\video\thumbnail.ps1" 2023-08-31_22-11-06.mp4 00:32:17 jpg
```
