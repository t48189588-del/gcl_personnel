// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'GCL 人事システム';

  @override
  String get selectYourRole => '役割を選択してください';

  @override
  String get seniorStaff => 'シニアスタッフ';

  @override
  String get juniorStaff => 'ジュニアスタッフ';

  @override
  String get developer => '開発者';

  @override
  String get commanderView => 'コマンダービュー - シニアスタッフ';

  @override
  String get metrics => 'メトリクス';

  @override
  String get guardrails => 'ガードレール設定';

  @override
  String get inviteStaff => 'スタッフ招待';

  @override
  String get exportExcel => 'Excelへエクスポート';

  @override
  String get searchHint => '名前または言語で検索';

  @override
  String get name => '名前';

  @override
  String get nativeLang => '母国語';

  @override
  String get degree => '学位';

  @override
  String get modality => '勤務形態';

  @override
  String get availRate => '出勤率';

  @override
  String get eventsPart => 'イベント参加数';

  @override
  String get assistance => 'サポート数';

  @override
  String get alerts => 'アラート';

  @override
  String get operatingHours => '曜日別営業時間';

  @override
  String get holidays => '休日と休業日';

  @override
  String get addHoliday => '休日を追加';

  @override
  String get holidayMessagePrompt => '休日のお知らせメッセージ';

  @override
  String get saveHoliday => '保存';

  @override
  String get inviteStaffButton => '招待を送信';

  @override
  String get emailLabel => 'メールアドレス';

  @override
  String get selfServicePortal => 'セルフサービス - ジュニアスタッフ';

  @override
  String get schedule => 'スケジュール';

  @override
  String get profile => 'プロフィール';

  @override
  String get noticeBoard => '掲示板';

  @override
  String get holidayNotice => '休業日';

  @override
  String get addBlock => '追加';

  @override
  String get removeBlock => '削除';

  @override
  String get emergencyReschedule => '緊急再スケジュール';

  @override
  String get personalProfile => '個人プロフィール';

  @override
  String get saveProfile => '保存して更新';

  @override
  String get developerDashboard => '開発者ダッシュボード';

  @override
  String get logs => 'システムログ';

  @override
  String get clearLogs => 'ログをクリア';

  @override
  String get allDay => '終日';

  @override
  String get startTime => '開始時間';

  @override
  String get endTime => '終了時間';

  @override
  String get prev => '前へ';

  @override
  String get next => '次へ';

  @override
  String get upgradeToSenior => 'シニアに昇進';

  @override
  String get eventProposal => 'イベント提案';

  @override
  String get attendanceReminder => '勤怠リマインダー確認';

  @override
  String get otherLanguages => 'その他の使用可能言語';

  @override
  String get uploadPhoto => 'プロフィール写真をアップロード';

  @override
  String get proposeEvent => 'イベントを提案する';

  @override
  String get proposalTitle => 'イベントタイトル';

  @override
  String get proposalDescription => 'イベント説明';

  @override
  String get proposedDate => '提案日';

  @override
  String get masterCalendarExport => 'マスターカレンダーエクスポート (月次)';

  @override
  String get attendanceWarning => 'こまめに勤怠を確認してください！';

  @override
  String get exportICS => 'ICSへエクスポート';

  @override
  String get toggleTheme => 'テーマ切替';

  @override
  String get role => '役職';

  @override
  String get day => '日';

  @override
  String get closed => '休業';

  @override
  String get currentlyStudying => '現在の専攻';

  @override
  String get originCountry => '出身国';

  @override
  String get cancel => 'キャンセル';

  @override
  String get selectDate => '日付を選択';

  @override
  String get openInviteLink => '招待リンクを開く';

  @override
  String get senior => 'シニア';

  @override
  String get junior => 'ジュニア';

  @override
  String get online => 'オンライン';

  @override
  String get inPerson => '対面';

  @override
  String get both => '両方';

  @override
  String get none => 'なし';

  @override
  String get mockEmailTitle => '模擬メールを受信しました！';

  @override
  String mockEmailContent(String email) {
    return '$email に確認メールを送信しました。\n\nリンクをクリックしてプロファイル設定をテストしてください。';
  }

  @override
  String get selectJuniorProfileTitle => 'ジュニアプロファイルを選択';

  @override
  String get proposalSubmitted => '提案が送信されました！';

  @override
  String get noAnnouncements => 'お知らせはありません。';

  @override
  String get developerDashboardTitle => '開発者ダッシュボード - システムログ';

  @override
  String get logEntryTypeAction => 'アクション';

  @override
  String get logEntryTypeInteraction => 'インタラクション';

  @override
  String get clearLogsTooltip => 'ログをクリア';

  @override
  String get currentlyStudyingHint => '何を学んでいますか？';

  @override
  String get originCountryHint => '出身はどこですか？';

  @override
  String get finishEmployment => '退職手続き';

  @override
  String get finishImmediately => '今すぐ';

  @override
  String get finishFutureDate => '退職予定日';

  @override
  String get employmentEndDialogTitle => '退職手続き';

  @override
  String get employmentEndDialogContent =>
      '最終出勤日を選択してください。その日付以降のスケジュールは無効になります。';

  @override
  String get selectModality => '勤務形態を選択';

  @override
  String get loading => '読み込み中...';

  @override
  String get noStaffLoggedIn => 'スタッフがログインしていません。';

  @override
  String get welcomeCompleteProfile => 'ようこそ！ポータルにアクセスするためにプロフィールを完成させてください。';

  @override
  String get completeYourProfile => 'プロフィールの完成';

  @override
  String get fullName => '氏名';

  @override
  String get completeSetupAndLogin => '設定を完了してログイン';

  @override
  String get personalDescription => '個人説明';
}
