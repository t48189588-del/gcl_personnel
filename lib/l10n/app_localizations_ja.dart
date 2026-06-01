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
  String get seniorStaff => 'メインスタッフ';

  @override
  String get juniorStaff => '学生アシスタント';

  @override
  String get developer => '開発者';

  @override
  String get commanderView => 'コマンダービュー - メインスタッフ';

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
  String get selfServicePortal => 'セルフサービス - 学生アシスタント';

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
  String get upgradeToSenior => 'メインスタッフに昇進';

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
  String get senior => 'メインスタッフ';

  @override
  String get junior => '学生アシスタント';

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
  String get selectJuniorProfileTitle => '学生アシスタントプロファイルを選択';

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
    return '学生アシスタントログイン: $name';
  }

  @override
  String logInvitedStaff(String email) {
    return 'スタッフを招待しました: $email';
  }

  @override
  String logUpgradedSenior(String name) {
    return '$name をメインスタッフにアップグレードしました';
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
  String get importStaffJson => 'スタッフ読込 (JSON)';

  @override
  String get importDataCsv => '予定・イベント読込 (CSV)';

  @override
  String get importSuccess => 'インポートに成功しました！';

  @override
  String importError(String error) {
    return 'インポートに失敗しました: $error';
  }

  @override
  String get fluentLanguages => '流暢な言語';

  @override
  String get commPreference => '連絡手段の希望';

  @override
  String byAuthorOnDate(Object author, Object date) {
    return '$dateに$authorによって提案されました';
  }

  @override
  String get charts => 'チャート';

  @override
  String get chartVisualizations => 'チャート視覚化';

  @override
  String get meetingRequests => '面談リクエスト';

  @override
  String get noMeetingRequests => '面談リクエストはありません。';

  @override
  String get chartApprovedHours => '時間帯別の承認済み時間';

  @override
  String get chartWorkedVsApproved => 'スタッフの実働時間と承認時間';

  @override
  String get chartLanguageProficiency => '言語習得度別の話者数';

  @override
  String get chartCumulativeHours => '日別の累計実働時間';

  @override
  String get chartAcademicStatus => '学位別のスタッフ数';

  @override
  String get noData => 'データなし';

  @override
  String get basic => '初級';

  @override
  String get intermediate => '中級';

  @override
  String get advanced => '上級';

  @override
  String get native => '母国語';

  @override
  String get weeklyHoursLimit => '週あたり稼働上限（最大）';

  @override
  String get weeklyHoursLimitHint => '上限時間（時間/週）を入力';

  @override
  String get weeklyLimitDialogTitle => '週上限に達しました';

  @override
  String weeklyLimitDialogContent(String limit) {
    return '週の上限（$limit時間）を超えています。緊急調整のためにこの時間帯を提出することは可能ですが、上限にご注意ください。';
  }

  @override
  String get holidaySlotBlocked => '祝日休館';

  @override
  String get requestMeeting => '面談を申し込む';

  @override
  String get scheduleMeetingWithGCL => 'GCLスタッフとの面談をスケジュール';

  @override
  String get meetingType => '面談タイプ';

  @override
  String get onlineTeams => 'オンライン [Teams]';

  @override
  String get department => '学部・学科';

  @override
  String get pleaseEnterName => 'お名前を入力してください';

  @override
  String get pleaseEnterDepartment => '学部・学科を入力してください';

  @override
  String get studyYear => '学年';

  @override
  String get purpose => '目的';

  @override
  String get pleaseSelectDate => '日付を選択してください';

  @override
  String get timeBlock => '時間帯 (30分枠)';

  @override
  String get pleaseSelectTime => '時間を選択してください';

  @override
  String get language => '言語';

  @override
  String get pleaseSelectLanguage => '言語を選択してください';

  @override
  String get meetingSubmittedSuccess => '面談リクエストが送信されました！';

  @override
  String get submitRequest => 'リクエスト送信';

  @override
  String get researchStudent => '研究生';

  @override
  String get assignment => '課題';

  @override
  String get conversation => '会話練習';

  @override
  String get presentationPractice => 'プレゼン練習';

  @override
  String get weeklyLimitDescription =>
      '学生アシスタントが申請できる週あたりの最大時間を指定してください（空欄の場合は制限なし）。';

  @override
  String get hoursSuffix => '時間';

  @override
  String get importCleanedJson => '整形済みJSON読込';

  @override
  String finishEmploymentConfirmTitle(String name) {
    return '退職手続き: $name';
  }

  @override
  String get finishEmploymentConfirmContent =>
      'このスタッフの雇用を終了してもよろしいですか？終了するとスケジュールへのアクセスが無効になります。';

  @override
  String get noAvailableStaff => 'この時間帯と言語に対応可能なスタッフが見つかりません。';

  @override
  String get assignStaff => 'スタッフを割り当て';

  @override
  String get meetingApprovedSuccess => '面談が承認され、スタッフが割り当てられました。';

  @override
  String get meetingRejectedSuccess => '面談リクエストが却下されました。';

  @override
  String get proceed => '続行';

  @override
  String logImportedStaff(String count) {
    return '$count 名のスタッフをインポートしました';
  }

  @override
  String logImportedCsvData(String rows) {
    return 'CSVから $rows 行のデータをインポートしました';
  }

  @override
  String get calendar => 'カレンダー';

  @override
  String get tasks => 'タスク';

  @override
  String get eventStartTime => '開始時間';

  @override
  String get eventEndTime => '終了時間';

  @override
  String get eventLocation => '場所';

  @override
  String get eventComments => 'コメント（任意）';

  @override
  String get eventDetails => 'イベント詳細';

  @override
  String get eventLogs => 'イベントログ';

  @override
  String get pendingApproval => '承認待ち';

  @override
  String get studentAssistant => '学生アシスタント';

  @override
  String get mainStaff => 'メインスタッフ';

  @override
  String get reservation => '予約';

  @override
  String get noReservation => '予約なし';

  @override
  String get todaySchedule => '本日のスケジュール';

  @override
  String get agendaNoticeBoard => 'アジェンダ＆掲示板';

  @override
  String get manageAvailability => 'シフト・スケジュール管理';

  @override
  String get proposalHistory => '提案履歴と承認後の詳細';

  @override
  String get holidayNoticeLabel => '休日のお知らせ';

  @override
  String get pendingReportsLabel => '未提出の報告書';

  @override
  String get upcomingMeetings => '今後の面談';

  @override
  String get noUpcomingMeetings => '今後の面談はありません。';

  @override
  String get noShiftsToday => '本日のシフトはありません。';

  @override
  String get postApprovalSNS => '承認後の詳細（SNS用）';

  @override
  String get eventSummarySNS => 'SNS用イベント概要';

  @override
  String get uploadPhotos => '写真をアップロード';

  @override
  String get saveDetails => '詳細を保存';

  @override
  String get detailsSaved => '情報が保存されました！';

  @override
  String get descriptionLabel => '説明';

  @override
  String get gclRoom => 'GCL教室';

  @override
  String get submittedReports => '提出済み報告書';

  @override
  String get noSubmittedReports => '提出済みの報告書はありません。';

  @override
  String get finished => '完了';

  @override
  String get weeklyHoursLimitHintShort => '上限時間（時間/週）を入力';
}
