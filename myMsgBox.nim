{.this: self.}
import wNim
import strutils

type
    wMyMsgBox = ref object of wFrame
        mWhichButton: wId
        panel: wPanel
        bt1: wButton
        bt2: wButton
        #~ clicked: wId

proc final(self: wMyMsgBox) =
    wFrame(self).final()

proc init(self: wMyMsgBox;
    title: string;
    message: string="";
    style: wStyle=wOK;
    size=wDefaultSize;
    fontMessage: wFont = Font(12, weight=wFontWeightBold);
    fontButton: wFont = Font(18, weight=wFontWeightBold);
    useStaticText=true;
    caption: string="";
    owner: wWindow=nil;
) =
    var (widFrame, hiFrame) = if size == wDefaultSize: wDefaultSize else: size

    echo "(widFrame, hiFrame)= ", (widFrame, hiFrame)


    wFrame(self).init(owner=owner, title=title, size=(widFrame, hiFrame), style=wModalFrame, )

    # 如果最初是wDefaultSize，那么是(-2147483648, -2147483648)，必须获取真实的数值
    (widFrame, hiFrame) = self.getSize()
    center()

    panel = Panel(self)

    var
        yDistance = 10
        (widPanel, hiPanel) = panel.getClientSize()
        #~ (widPanel, hiPanel) = panel.getSize()

        hiTxtCtrl = int(0.75 * float(hiPanel))

        #~ staticText: wStaticText | wTextCtrl
        #~ staticText: wTextCtrl

    echo "(widPanel, hiPanel)= ", (widPanel, hiPanel)
    #~ when useStaticText:#true:
        #~ var staticText = StaticText(panel,
            #~ label=message,
            #~ pos=(yDistance, yDistance*2),
            #~ size=(widPanel - yDistance*2, hiTxtCtrl),
            #~ style=wTeRich
        #~ )
        #~ discard
    #~ else:
    when true:
        var staticText = TextCtrl(panel,
            value=message,
            pos=(yDistance, yDistance*2),
            size=(widPanel - yDistance*2, hiTxtCtrl),
            style=wTeRich or wTeMultiLine or wTeReadOnly
        )
    staticText.font = fontMessage

    var
        (widStaticTxt, hiStaticTxt) = staticText.getSize()#ClientSize()
        sizeButton = (int((widPanel-9*yDistance)/3), hiPanel - hiStaticTxt - yDistance*6)

        numOfButtons = 1
        listLabelButtons:seq[string] = @[]
        listButton:seq[wButton] = @[]
        listRuturn:seq[wId] = @[]

    echo "sizeButton= ",sizeButton
    echo "(widStaticTxt, hiStaticTxt) = ", (widStaticTxt, hiStaticTxt)
    self.wEvent_Close do (event: wEvent):
        event.veto()

    #[
    常數	值	描述
vbOKOnly	0	僅顯示 [確定] 按鈕。
vbOKCancel	1	顯示 [確定] 和 [取消] 按鈕。
vbAbortRetryIgnore	2	顯示 [中止]、[重試] 和 [略過] 按鈕。
vbYesNoCancel	3	顯示 [是]、[否] 和 [取消] 按鈕。
vbYesNo	4	顯示 [是] 和 [否] 按鈕。
vbRetryCancel	5	顯示 [重試] 和 [取消] 按鈕。

vbCritical	16	顯示 [重要訊息] 圖示。
vbQuestion	32	顯示 [警告查詢] 圖示。
vbExclamation	48	顯示 [警告訊息] 圖示。
vbInformation	64	顯示 [資訊訊息] 圖示。

vbDefaultButton1	0	預設值是第一個按鈕。
vbDefaultButton2	256	預設值是第二個按鈕。
vbDefaultButton3	512	預設值是第三個按鈕。
vbDefaultButton4	768	預設值是第四個按鈕。
vbApplicationModal	0	應用程式強制回應；使用者必須回應訊息方塊，才能繼續使用目前的應用程式。
vbSystemModal	4096	系統強制回應；所有應用程式會暫停，直到使用者回應訊息方塊。
vbMsgBoxHelpButton	16384	將 [說明] 按鈕新增至訊息方塊。
VbMsgBoxSetForeground	65536	指定訊息方塊視窗做為前景視窗。
vbMsgBoxRight	524288	靠右對齊文字。
vbMsgBoxRtlReading	1048576	指定希伯來文和阿拉伯文系統上文字應該由右向左顯示。


##   wOk                             The message box contains one push button: OK. This is the default.
##   wYesNo                          The message box contains two push buttons: Yes and No.
##   wOkCancel                       The message box contains two push buttons: OK and Cancel.
##   wYesNoCancel                    The message box contains three push buttons: Yes, No, and Cancel.
##   wRetryCancel                    The message box contains two push buttons: Retry and Cancel.
##   wAbortRetryIgnore               The message box contains three push buttons: Abort, Retry, and Ignore.
##   wCancelTryContinue              The message box contains three push buttons: Cancel, Try Again, Continue.

##   wIconHand                       A stop-sign icon appears in the message box.
##   wIconErr                        A stop-sign icon appears in the message box.
##   wIconStop                       A stop-sign icon appears in the message box.
##   wIconQuestion                   A question-mark icon appears in the message box.
##   wIconExclamation                An exclamation-point icon appears in the message box.
##   wIconWarning                    An exclamation-point icon appears in the message box.
##   wIconInformation                An icon consisting of a lowercase letter i in a circle appears in the message box.
##   wIconAsterisk                   An icon consisting of a lowercase letter i in a circle appears in the message box.

##   wButton1_Default                The first button is the default button. This is the default.
##   wButton2_Default                The second button is the default button.
##   wButton3_Default                The third button is the default button.
##   wButton4_Default                The fourth button is the default button.
##   wStayOnTop                      The message box will stay on top of all other windows.

]#
    var typeButton = int(style) and 0b1111
    echo typeButton
    case typeButton:
    of int(wOk):
        numOfButtons = 1
        listLabelButtons.add("确定")
        listRuturn.add(wIdOk)
    of int(wYesNo):
        numOfButtons = 2
        listLabelButtons.add("是(&Y)")
        listLabelButtons.add("否(&N)")
        listRuturn.add(wIdYes)
        listRuturn.add(wIdNo)
    of wOkCancel:
        numOfButtons = 2
        listLabelButtons.add("确定(&Y)")
        listLabelButtons.add("取消(&C)")
        listRuturn.add(wIdOk)
        listRuturn.add(wIdCancel)
    of wYesNoCancel:
        numOfButtons = 3
        listLabelButtons.add("是(&Y)")
        listLabelButtons.add("否(&N)")
        listLabelButtons.add("取消(&C)")

        listRuturn.add(wIdYes)
        listRuturn.add(wIdNo)
        listRuturn.add(wIdCancel)
    of wRetryCancel:
        numOfButtons = 2
        listLabelButtons.add("重试(&R)")
        listLabelButtons.add("取消(&C)")

        listRuturn.add(wIdRetry)
        listRuturn.add(wIdCancel)
    of wAbortRetryIgnore:
        numOfButtons = 3
        listLabelButtons.add("终止(&A)")
        listLabelButtons.add("重试(&R)")
        listLabelButtons.add("忽略(&I)")

        listRuturn.add(wIdAbort)
        listRuturn.add(wIdRetry)
        listRuturn.add(wIdIgnore)
    of wCancelTryContinue:
        numOfButtons = 3
        listLabelButtons.add("取消(&C)")
        listLabelButtons.add("重试(&R)")
        listLabelButtons.add("继续(&O)")

        listRuturn.add(wIdCancel)
        listRuturn.add(wIdTryAgain)
        listRuturn.add(wIdContinue)

    else:
        discard

    echo "typeButton= ", toHex(typeButton)
    echo "numOfButtons= ", numOfButtons
    echo listLabelButtons

    var typeIcon = style and 0xF0
    echo "typeIcon= ", toHex(typeIcon)
    #~ case typeIcon:
    #~ of   wIconHand* = MB_ICONHAND
  #~ wIconErr* = MB_ICONERROR
  #~ wIconStop* = MB_ICONSTOP
  #~ wIconQuestion* = MB_ICONQUESTION
  #~ wIconExclamation* = MB_ICONEXCLAMATION
  #~ wIconWarning* = MB_ICONWARNING
  #~ wIconInformation* = MB_ICONINFORMATION
  #~ wIconAsterisk* = MB_ICONASTERISK

    var
        pos = (0, 0)
        lastX = int((widPanel - sizeButton[0]*numOfButtons - yDistance*(numOfButtons-1))/2)
        lastY = hiStaticTxt + yDistance*4
        tmpButton: wButton
    for idxButton in 0 .. (numOfButtons-1):
        pos = (lastX, lastY)
        tmpButton = Button(panel,
                label=listLabelButtons[idxButton],
                pos=pos,
                size=sizeButton
        )
        tmpButton.font = fontButton

        closureScope:
            var idxButtonLoc = idxButton
            tmpButton.wEvent_Button do (event: wEvent):
                echo "listRuturn= ", listRuturn
                echo idxButton, " ", idxButtonLoc
                self.mWhichButton = listRuturn[idxButtonLoc]

                self.endModal()
                self.close()

        lastX += sizeButton[0] + yDistance

proc show(self: wMyMsgBox): wId {.inline, discardable.}=
    self.showModal()
    return self.mWhichButton

proc MyMsgBox(
    caption: string="";
    title: string="";
    message: string="";
    owner: wWindow=nil;
    style: wStyle=wOK;
    size=wDefaultSize;
    useStaticText=true;
    fontMessage: wFont | int =12;
    fontButton: wFont | int =18;
): wMyMsgBox {.inline.} =
    new(result, final)

    var
        strCaption: string = ""
        fontTmpMessage: wFont = Font(12, weight=wFontWeightBold)
        fontTmpButton: wFont = Font(18, weight=wFontWeightBold)

    if caption != "":
        strCaption = caption
    elif title != "":
        strCaption = title

    when (fontMessage is float) or (fontMessage is int) :
        fontTmpMessage = Font(float fontMessage, weight=wFontWeightBold)
    else:
        fontTmpMessage = fontMessage

    when (fontButton is float) or (fontButton is int):
        fontTmpButton = Font(float fontButton, weight=wFontWeightBold)
    else:
        fontTmpButton = fontButton

    result.init(title=strCaption,
        style=style,
        message=message,
        owner=owner,
        size=size,
        fontMessage=fontTmpMessage,
        fontButton=fontTmpButton,
    )

when isMainModule:
    let
        app = App()
        frame = Frame()
        panel = Panel(frame)
        bt = Button(panel, label="click")

    bt.wEvent_Button do (event: wEvent):
        let MyMsgBox = MyMsgBox(owner=frame,
            title="Hello World",
            style=wCancelTryContinue or wIconHand,
            message="wdwewer ".repeat(10),
            fontMessage = Font(12, weight=wFontWeightBold),
            fontButton = Font(18, weight=wFontWeightBold)

            )
        echo MyMsgBox.show()

    frame.show()
    app.mainLoop()

