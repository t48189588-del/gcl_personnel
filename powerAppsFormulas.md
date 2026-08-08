# App OnStart property

```
With(
    {
        CurrentNow: Now(),
        TargetEmail: User().Email
    },
    Set(
        varCurrentUserRecord,
        LookUp(スタッフ, メール = TargetEmail)
    );
    Set(
        varCleanLanguageCode,
        Right(Trim(varCurrentUserRecord.母語), 2)
    );
    Set(
        varCurrentDecimalHour,
        Hour(CurrentNow) + (Minute(CurrentNow) / 60)
    );
    With(
        {
            CurrentMinutes: Minute(CurrentNow),
            CurrentSeconds: Second(CurrentNow)
        },
        Set(
            varDynamicDuration,
            ((If(CurrentMinutes < 30, 30 - CurrentMinutes, 60 - CurrentMinutes) * 60) - CurrentSeconds) * 1000
        )
    )
);

With(
    {
        OffsetMin: TimeZoneOffset(),
        BaseDate: Today()
    },
    Set(
        varTokyoToday,
        DateAdd(BaseDate, -OffsetMin, TimeUnit.Minutes)
    )
);

With(
    {
        DayEndBoundary: DateAdd(varTokyoToday, 24, TimeUnit.Hours),
        IsUserNotMain: varCurrentUserRecord.スタッフ.Value <> "Main staff",
        UserNickname: varCurrentUserRecord.nickname
    },
    ClearCollect(
        colTodayShifts,
        AddColumns(
            Filter(
                schedules,
                proposed_start >= varTokyoToday And proposed_start < DayEndBoundary And (IsUserNotMain = false Or アシスタン = UserNickname)
            ),
            shift_start, DateAdd(proposed_start, TimeZoneOffset(), TimeUnit.Minutes),
            shift_end, DateAdd(proposed_end, TimeZoneOffset(), TimeUnit.Minutes),
            finalStatus, status.Value,
            student, アシスタン,
            nationality, 'staff: 国'
        )
    )
);

With(
    {
        FirstDayOfMonth: Date(Year(Now()), Month(Now()), 1),
        LastDayOfMonth: DateAdd(Date(Year(Now()), Month(Now()) + 1, 1), -1, TimeUnit.Days),
        CalcCurrentMonthStart: Date(Year(Today()), Month(Today()), 1)
    },
    ClearCollect(
        reports,
        Filter(レポート, proposed_start >= FirstDayOfMonth And proposed_start <= LastDayOfMonth)
    );
    Set(gblCurrentMonthStart, CalcCurrentMonthStart);
    Set(gblNextMonthStart, DateAdd(CalcCurrentMonthStart, 1, TimeUnit.Months));
    Set(gblNextMonthEnd, DateAdd(DateAdd(CalcCurrentMonthStart, 2, TimeUnit.Months), -1, TimeUnit.Days));
    If(
        IsBlank(lblSelectedMonthStart),
        Set(lblSelectedMonthStart, DateAdd(CalcCurrentMonthStart, 1, TimeUnit.Months))
    )
);

Set(varShowAllSchedules, false);
Set(actualStart, "");
Set(activityStatus, "existing");
Set(availScheduleSelector, Coalesce(availScheduleSelector, "month"));

Concurrent(
    Set(varWelcomeText, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Welcome, ")),
    Set(vartodayDate, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, Text(varTokyoToday, "mmmm dd, (ddd)"))),
    Set(screenHeader, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, varCurrentUserRecord.スタッフ.Value & " - Main screen")),
    Set(varShowAll, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Show all schedules")),
    Set(varStartShiftMessage, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "🔴 Current Status: Shift In Progress")),
    Set(varFinishShiftMessage, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "🟢 Current Status: Off the Clock")),
    Set(varCancel, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Cancel Shift")),
    Set(varReservation, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Assigned Reservations")),
    Set(proposedStart, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Proposed Start: ")),
    Set(proposedEnd, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Proposed End: ")),
    Set(varActualStart, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Actual start: ")),
    Set(varActualEnd, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Actual end: ")),
    Set(varCurrentTimeOnly, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Show current time block only")),
    Set(varCompleted, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Completed")),
    Set(varUncompleted, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "available")),
    Set(varHintText, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Please type your end-of-shift report summary")),
    Set(staffScheduleReminder, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Shifts are set at the end of every month. Please enter your available time slots by the 25th of each month")),
    Set(upcomingAgenda, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Upcoming Agenda")),
    Set(date, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "date")),
    Set(submitTime, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Total available submission time (hh:mm): ")),
    Set(expectedPay, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Expected Pay: ")),
    Set(prev, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Previous")),
    Set(next, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Next")),
    Set(submit, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Submit")),
    Set(exportCalendar, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Export to calendar")),
    Set(rate, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Hourly rate: ")),
    Set(pendingReport, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Pending reports: ")),
    Set(totalReport, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Total reports: ")),
    Set(totalWorkedHours, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Total worked hours: ")),
    Set(varfullName, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "氏名: ")),
    Set(varnickname, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "nickname: ")),
    Set(varEmail, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Email: ")),
    Set(varCountry, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Country: ")),
    Set(varmotherLanguage, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "母語: ")),
    Set(varOtherLanguages, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "他の言語: ")),
    Set(varCampus, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "キャンパス: ")),
    Set(varStaffType, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Staff type: ")),
    Set(varAboutMe, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "私について: ")),
    Set(varAcademicLevel, MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Academic Label: ")),
    Set(reservationFilter, "pending"),
    Set(availScheduleSelector, "day")
);

With(
    {UserTodayShifts: Filter(colTodayShifts, student = varCurrentUserRecord.nickname)},
    With(
        {
            NextShift: First(Sort(UserTodayShifts, If(finalStatus = "approved", 0, 1), SortOrder.Ascending))
        },
        With(
            {
                IsShiftEmpty: IsEmpty(UserTodayShifts),
                NextShiftStart: NextShift.proposed_start,
                NextShiftEnd: NextShift.proposed_end,
                MinutesUntilStart: If(!IsEmpty(UserTodayShifts) And !IsBlank(NextShift.proposed_start), DateDiff(Now(), NextShift.proposed_start, TimeUnit.Minutes), 0),
                CurrentTime: Now()
            },
            Concurrent(
                Set(
                    varShiftStatusMessage,
                    MicrosoftTranslatorV2.Translate(
                        varCleanLanguageCode,
                        If(
                            IsShiftEmpty,
                            "No active shifts scheduled for today, enjoy the freedom !",
                            MinutesUntilStart > 15,
                            "Upcoming shift scheduled today Shift: " & Text(NextShift.shift_start, DateTimeFormat.ShortTime24) & "-" & Text(NextShift.shift_end, DateTimeFormat.ShortTime24) & " Clock-in opens 30 minutes before start time.",
                            CurrentTime >= DateAdd(NextShiftStart, -30, TimeUnit.Minutes) And CurrentTime <= NextShiftEnd,
                            If(varIsClockedIn, "Shift in progress. Remember to log your live notes as you work!", "Your shift is ready to begin. Please clock in now."),
                            "Shift completed. Please complete your pending working report."
                        )
                    )
                ),
                Set(
                    varWorkState,
                    If(IsShiftEmpty, "NoShift", MinutesUntilStart > 30, "Locked", CurrentTime >= DateAdd(NextShiftStart, -30, TimeUnit.Minutes) And CurrentTime <= NextShiftEnd, If(varIsClockedIn, "ActiveShift", "ReadyToClockIn"), "PastShift")
                ),
                Set(
                    varButtonLabel,
                    MicrosoftTranslatorV2.Translate(varCleanLanguageCode, If(IsShiftEmpty, "No active shifts scheduled right now", "Register shift start"))
                )
            )
        )
    )
);

If(
    varCurrentUserRecord.スタッフ.Value <> "Main staff",
    ClearCollect(
        colNavigation,
        {ID: 1, ScreenName: MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Calendar"), displayIcon: Icon.CalendarBlank},
        {ID: 2, ScreenName: MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Reports"), displayIcon: Icon.Document},
        {ID: 3, ScreenName: MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Scheduling"), displayIcon: Icon.AddToCalendar},
        {ID: 4, ScreenName: MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Profile"), displayIcon: Icon.Person}
    );
    ,
    With(
        {RawStaff: Filter(スタッフ, スタッフ.Value <> "Main staff")},
        ClearCollect(
            colStaffList,
            AddColumns(
                Sort(Filter(Distinct(RawStaff, nickname), !IsBlank(Value)), Value, SortOrder.Ascending),
                approvedHours,
                Sum(Filter(colTodayShifts, student = Value And finalStatus = "approved"), approvedHours)
            )
        )
    );
    ClearCollect(
        colNavigation,
        {ID: 1, ScreenName: MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Schedules"), displayIcon: Icon.CalendarBlank},
        {ID: 2, ScreenName: MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Reports"), displayIcon: Icon.Document},
        {ID: 3, ScreenName: MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Reservations"), displayIcon: Icon.ListScrollWatchlist},
        {ID: 4, ScreenName: MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Staff"), displayIcon: Icon.People},
        {ID: 5, ScreenName: MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Events"), displayIcon: Icon.BookmarkFilled}
        //{ID: 6, ScreenName: MicrosoftTranslatorV2.Translate(varCleanLanguageCode, "Information"), displayIcon: Icon.Information}
    );
    With(
        {
            MinShift: Min(colTodayShifts, shift_start),
            MaxShift: Max(colTodayShifts, shift_end)
        },
        With(
            {
                CalculatedMinStart: Coalesce(Hour(MinShift) + (Minute(MinShift) / 60), 0),
                CalculatedMaxEnd: Coalesce(Hour(MaxShift) + (Minute(MaxShift) / 60), 0)
            },
            With(
                {
                    TotalBlocks: Abs((CalculatedMaxEnd - CalculatedMinStart) * 2),
                    MinStartConst: CalculatedMinStart
                },
                Set(varMinStartHour, CalculatedMinStart);
                Set(varMaxEndHour, CalculatedMaxEnd);
                Set(varTotalBlocks, TotalBlocks);
                ClearCollect(
                    colAdminTimeBlocks,
                    Filter(
                        ForAll(
                            Sequence(TotalBlocks, 0),
                            With(
                                {
                                    SVal: MinStartConst + (Value * 0.5),
                                    EVal: MinStartConst + ((Value + 1) * 0.5)
                                },
                                {
                                    StartVal: SVal,
                                    EndVal: EVal,
                                    SlotText: Time(Trunc(SVal), (SVal - Trunc(SVal)) * 60, 0) & "-" & Time(Trunc(EVal), (EVal - Trunc(EVal)) * 60, 0)
                                }
                            )
                        ),
                        CountRows(Filter(colTodayShifts, (Hour(shift_start) + Minute(shift_start) / 60) <= StartVal And (Hour(shift_end) + Minute(shift_end) / 60) >= EndVal)) > 0
                    )
                )
            )
        )
    )
);

Set(
    varSelectedMonth,
    Date(
        Year(Today()),
        Month(Today()) + 1,
        1
    )
);

Set(
    varLocation,
    "Local"
);

Set(
    varViewMode,
    "Week"
);
Set(
    varSelectedMonth,
    Date(
        Year(Today()),
        Month(Today()) + 1,
        1
    )
);

Set(
    varLocation,
    "Local"
);

Set(
    varViewMode,
    "Week"
);

ClearCollect(
    colUserSchedule,
    Filter(
        schedules,
        proposed_start >= gblCurrentMonthStart &&
        proposed_end <= gblNextMonthEnd
    )
);

ClearCollect(
    colAvailabilityRules,

    {WeekDayNumber:1, StartTime:Time(11,0,0), EndTime:Time(14,0,0)},
    {WeekDayNumber:2, StartTime:Time(11,0,0), EndTime:Time(14,0,0)},
    {WeekDayNumber:3, StartTime:Time(11,0,0), EndTime:Time(14,0,0)},
    {WeekDayNumber:4, StartTime:Time(11,0,0), EndTime:Time(14,0,0)},
    {WeekDayNumber:5, StartTime:Time(11,0,0), EndTime:Time(14,0,0)},

    {WeekDayNumber:1, StartTime:Time(16,0,0), EndTime:Time(18,0,0)},
    {WeekDayNumber:2, StartTime:Time(16,0,0), EndTime:Time(18,0,0)},
    {WeekDayNumber:3, StartTime:Time(16,0,0), EndTime:Time(18,0,0)},
    {WeekDayNumber:4, StartTime:Time(16,0,0), EndTime:Time(20,0,0)},
    {WeekDayNumber:5, StartTime:Time(16,0,0), EndTime:Time(20,0,0)}
);

Clear(colScheduleTemplate);

ForAll(
    Sequence(
        DateDiff(
            varSelectedMonth,
            DateAdd(
                varSelectedMonth,
                1,
                TimeUnit.Months
            ),
            TimeUnit.Days
        )
    ),

    With(
        {
            CurrentDate:DateAdd(varSelectedMonth,Value - 1,TimeUnit.Days)
        },

        If(
            Weekday(CurrentDate,StartOfWeek.Monday) <= 5,
            ForAll(
                Filter(
                    colAvailabilityRules,
                    WeekDayNumber =
                    Weekday(
                        CurrentDate,
                        StartOfWeek.Monday
                    )
                ),

                With(
                    {
                        RuleStart: StartTime,
                        RuleEnd: EndTime,

                        Blocks:
                            DateDiff(
                                StartTime,
                                EndTime,
                                TimeUnit.Minutes
                            ) / 30
                    },

                    ForAll(

                        Sequence(Blocks),

                        Collect(

                            colScheduleTemplate,

                            {

                                BlockDate: CurrentDate,

                                WeekDay:
                                Weekday(
                                    CurrentDate,
                                    StartOfWeek.Monday
                                ),

                                BlockStart:
                                DateAdd(
                                    RuleStart,
                                    (Value - 1) * 30,
                                    TimeUnit.Minutes
                                ),

                                BlockEnd:
                                DateAdd(
                                    RuleStart,
                                    Value * 30,
                                    TimeUnit.Minutes
                                ),

                                IsSelected: false,

                                SelectedLocation: Blank()

                            }

                        )

                    )

                )

            )

        )

    )

);
ClearCollect(
    colTimeAxis,

    {SortOrder:1, DisplayTime:"11:00", TimeValue:Time(11,0,0)},
    {SortOrder:2, DisplayTime:"11:30", TimeValue:Time(11,30,0)},
    {SortOrder:3, DisplayTime:"12:00", TimeValue:Time(12,0,0)},
    {SortOrder:4, DisplayTime:"12:30", TimeValue:Time(12,30,0)},
    {SortOrder:5, DisplayTime:"13:00", TimeValue:Time(13,0,0)},
    {SortOrder:6, DisplayTime:"13:30", TimeValue:Time(13,30,0)},

    {SortOrder:7, DisplayTime:"16:00", TimeValue:Time(16,0,0)},
    {SortOrder:8, DisplayTime:"16:30", TimeValue:Time(16,30,0)},
    {SortOrder:9, DisplayTime:"17:00", TimeValue:Time(17,0,0)},
    {SortOrder:10, DisplayTime:"17:30", TimeValue:Time(17,30,0)},
    {SortOrder:11, DisplayTime:"18:00", TimeValue:Time(18,0,0)},
    {SortOrder:12, DisplayTime:"18:30", TimeValue:Time(18,30,0)},
    {SortOrder:13, DisplayTime:"19:00", TimeValue:Time(19,0,0)},
    {SortOrder:14, DisplayTime:"19:30", TimeValue:Time(19,30,0)}
);
```