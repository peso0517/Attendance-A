# config/initierlizers/time_formats.rb
# default => "2014-10-01 09:00:00 +0900"のため変更をかける。以下qiitaより引用https://qiita.com/Vit-Symty/items/399c77d1fd681b77d593

Time::DATE_FORMATS[:default] = '%H:%M' #修正が必要
Time::DATE_FORMATS[:datetime] = '%H:%M' #修正が必要
Time::DATE_FORMATS[:date] = '%Y/%m/%d'
Time::DATE_FORMATS[:time] = '%H:%M:%S'
Date::DATE_FORMATS[:default] = '%m/%d' #勤怠表示画面→月初、月末表示用に修正