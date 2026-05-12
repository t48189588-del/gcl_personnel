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

  @override
  String get workingReports => '業務報告';

  @override
  String get submitReport => '報告書を提出';

  @override
  String get reportPending => '報告待ち';

  @override
  String get pendingReportsNotice => '未提出の業務報告書があります。';

  @override
  String get confirmedStartTime => '確定開始時刻';

  @override
  String get confirmedEndTime => '確定終了時刻';

  @override
  String get workDoneLabel => '業務内容';

  @override
  String get workDoneHint => 'このシフト中の業務内容を記入してください';

  @override
  String get reportDate => '報告日';

  @override
  String get scheduledTime => '予定時刻';

  @override
  String get workedHours => '実働時間';

  @override
  String get missingReport => '未提出';

  @override
  String get filledReport => '提出済み';

  @override
  String get affiliation => '所属';

  @override
  String get helpConfirmedTime => '実際の勤務時間に合わせて開始・終了時刻を調整してください。';

  @override
  String get helpWorkDone => 'このシフト中に行った業務や成果を簡潔に記入してください。';

  @override
  String get socialMetrics => 'ソーシャルメディア指標';

  @override
  String get refreshMetrics => '指標を更新';

  @override
  String get kanaName => 'フリガナ (かな)';

  @override
  String get mon => '月';

  @override
  String get tue => '火';

  @override
  String get wed => '水';

  @override
  String get thu => '木';

  @override
  String get fri => '金';

  @override
  String get sat => '土';

  @override
  String get sun => '日';

  @override
  String get status => 'ステータス';

  @override
  String get approve => '承認';

  @override
  String get reject => '却下';

  @override
  String get totalHours => '合計時間';

  @override
  String get proposed => '申請中';

  @override
  String get approved => '承認済み';

  @override
  String get rejected => '却下済み';

  @override
  String get nextMonthSchedule => '来月のシフト申請';

  @override
  String get approveAll => 'すべて承認';

  @override
  String get proposerName => '提案者';

  @override
  String get bulkApprove => '一括承認';

  @override
  String get bulkReject => '一括却下';

  @override
  String get phoneNumber => '電話番号';

  @override
  String get employment => '雇用管理';

  @override
  String get youtubeStats => 'YouTube 統計';

  @override
  String get instagramStats => 'Instagram 統計';

  @override
  String get xStats => 'X (Twitter) 統計';

  @override
  String get week => '週';

  @override
  String get month => '月';

  @override
  String get noPendingShifts => 'この期間の保留中のシフトはありません';

  @override
  String get noEventProposals => 'イベント提案はまだありません。';

  @override
  String get actionRequiredReports => '要対応: 未提出の業務報告書を完了してください';

  @override
  String get date => '日付';

  @override
  String get fillReport => '報告書を作成';

  @override
  String logLocaleSwitched(String locale) {
    return '言語を $locale に切り替えました';
  }

  @override
  String logThemeSwitched(String mode) {
    return 'テーマモードを $mode に切り替えました';
  }

  @override
  String logJuniorLogin(String name) {
    return 'ジュニアログイン: $name';
  }

  @override
  String logInvitedStaff(String email) {
    return 'スタッフを招待しました: $email';
  }

  @override
  String logUpgradedSenior(String name) {
    return '$name をシニアにアップグレードしました';
  }

  @override
  String logFinishedEmployment(String name, String date) {
    return '$name の雇用を終了しました (終了日: $date)';
  }

  @override
  String logUpdatedDaySchedule(String day, String range, bool closed) {
    return '$day のスケジュールを更新しました: $range (休業: $closed)';
  }

  @override
  String logAddedHolidays(int count) {
    return '$count 日間の休日を追加しました';
  }

  @override
  String logRemovedHoliday(String date) {
    return '$date の休日を削除しました';
  }

  @override
  String logEventProposal(String title, String name) {
    return 'イベント提案: $title ($name による)';
  }

  @override
  String logCompletedSetup(String name) {
    return '$name の初期設定が完了しました';
  }

  @override
  String logUpdatedProfile(String name) {
    return '$name のプロフィールを更新しました';
  }

  @override
  String logAddedBlock(String staffId, String time) {
    return '$staffId のブロックを $time に追加しました';
  }

  @override
  String logRemovedBlock(String id) {
    return 'ブロック $id を削除しました';
  }

  @override
  String logEmergencyReschedule(String id) {
    return 'ブロック $id の緊急再スケジュールが実行されました';
  }

  @override
  String logUpdatedBlockModality(String id, String modality) {
    return 'ブロック $id の勤務形態を $modality に更新しました';
  }

  @override
  String logApprovedBlock(String id) {
    return 'ブロック $id を承認しました';
  }

  @override
  String logApprovedMultipleBlocks(int count) {
    return '$count 件のブロックを承認しました';
  }

  @override
  String logRejectedMultipleBlocks(int count) {
    return '$count 件のブロックを却下しました';
  }

  @override
  String logUpdatedProposalStatus(String id, String status) {
    return '提案 $id のステータスを $status に更新しました';
  }

  @override
  String logApprovedAllBlocks(String staffId, String month) {
    return '$month の $staffId のすべての提案ブロックを承認しました';
  }

  @override
  String logSubmittedReport(String date) {
    return '$date の業務報告書が提出されました';
  }

  @override
  String get logClearedLogs => 'ログをクリアしました';

  @override
  String get bachelors => '学士';

  @override
  String get masters => '修士';

  @override
  String get phd => '博士';

  @override
  String get research => '研究生';

  @override
  String get subscribers => '登録者数';

  @override
  String get followers => 'フォロワー';

  @override
  String get views => '視聴回数';

  @override
  String get posts => '投稿数';

  @override
  String get error => 'エラー';

  @override
  String get exportAllReportsTooltip => 'すべての業務報告書をエクスポート (複数ファイル)';

  @override
  String get selectDaysPrompt => '日付を選択 (タップで切り替え):';

  @override
  String get selectStaffPrompt => '報告書を表示するスタッフを選択してください。';

  @override
  String get exportCsv => 'CSVエクスポート';

  @override
  String get fluentLanguages => '流暢な言語';

  @override
  String get commPreference => '連絡手段の希望';

  @override
  String byAuthorOnDate(Object author, Object date) {
    return '$dateに$authorによって提案されました';
  }
}
