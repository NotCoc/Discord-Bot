using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI}
using { /UnrealEngine.com/Temporary/SpatialMath}
using { /Fortnite.com/UI }
using { /Verse.org/Colors }
using { /Verse.org/Colors/NamedColors }

passcode := class<concrete>:
    @editable PIN : int = 0
    @editable SuccessTrigger : ?trigger_device = false

pinpad_device := class(creative_device):

    var StuffPerAgent : [agent]?tuple(canvas,text_block,string) = map{}

    @editable AssignPinPadButton : button_device = button_device{}
    @editable FailTrigger : trigger_device = trigger_device{}
    @editable SuccessTrigger : trigger_device = trigger_device{}
    @editable Passcodes : []passcode = array{}
    
    # UI Colors - fully customizable
    @editable BackgroundColor : color = color{R:=0.96,G:=0.96,B:=0.97}
    @editable PanelColor : color = color{R:=1.0,G:=1.0,B:=1.0}
    @editable TitleColor : color = color{R:=0.25,G:=0.25,B:=0.3}
    @editable DisplayBackgroundColor : color = color{R:=0.92,G:=0.92,B:=0.94}
    @editable DisplayTextColor : color = color{R:=0.2,G:=0.2,B:=0.3}
    @editable ButtonColor : color = color{R:=0.94,G:=0.94,B:=0.95}
    @editable ButtonTextColor : color = color{R:=0.2,G:=0.2,B:=0.3}
    @editable Button0Color : color = color{R:=0.4,G:=0.85,B:=0.95}
    @editable ButtonBackColor : color = color{R:=1.0,G:=0.7,B:=0.5}
    @editable ButtonEnterColor : color = color{R:=0.5,G:=0.9,B:=0.7}
    @editable ButtonCloseColor : color = color{R:=0.95,G:=0.5,B:=0.5}

    # UI Dimensions
    @editable UIWidth : float = 420.0
    @editable UIHeight : float = 600.0
    @editable ButtonWidth : float = 95.0
    @editable ButtonHeight : float = 80.0
    @editable MaxInputLength : int = 10 # Input limit

    OnBegin<override>()<suspends>:void=
        AssignPinPadButton.InteractedWithEvent.Subscribe(AddPinPad)

    S2M<localizes>(S:string):message="{S}"

    AddPinPad(A:agent):void=
        if(Stuff:=StuffPerAgent[A]?):
            #Do not assign
        else:
            Val:=MakeCanvas()
            if:
                PlayerUI:=GetPlayerUI[player[A]]
            then:
                PlayerUI.AddWidget(Val(0),player_ui_slot{InputMode:=ui_input_mode.All})
                if(set StuffPerAgent[A] = option{(Val(0),Val(1),"")}){}

    RemovePinPad(A:agent):void=
        if(Stuff:=StuffPerAgent[A]?):
            if:
                PlayerUI:=GetPlayerUI[player[A]]
            then:
                PlayerUI.RemoveWidget(Stuff(0))
                if(set StuffPerAgent[A] = false){}

    # Helper function to create button with color background and text
    CreateButton(Btn:button_quiet, Col:color, Txt:text_block, W:float, H:float):overlay=
        overlay:
            Slots:=array:
                overlay_slot: # Color background
                    Widget:=color_block{DefaultColor:=Col, DefaultDesiredSize:=vector2{X:=W, Y:=H}}
                    HorizontalAlignment:=horizontal_alignment.Fill
                    VerticalAlignment:=vertical_alignment.Fill
                overlay_slot: # Button on top of background
                    Widget:=Btn
                    HorizontalAlignment:=horizontal_alignment.Fill
                    VerticalAlignment:=vertical_alignment.Fill
                overlay_slot: # Text on top
                    Widget:=Txt
                    HorizontalAlignment:=horizontal_alignment.Center
                    VerticalAlignment:=vertical_alignment.Center

    MakeCanvas():tuple(canvas,text_block)=
        # Create invisible buttons
        Button0 := button_quiet{}
        Button0.OnClick().Subscribe(Add0)
        Button1 := button_quiet{}
        Button1.OnClick().Subscribe(Add1)
        Button2 := button_quiet{}
        Button2.OnClick().Subscribe(Add2)
        Button3 := button_quiet{}
        Button3.OnClick().Subscribe(Add3)
        Button4 := button_quiet{}
        Button4.OnClick().Subscribe(Add4)
        Button5 := button_quiet{}
        Button5.OnClick().Subscribe(Add5)
        Button6 := button_quiet{}
        Button6.OnClick().Subscribe(Add6)
        Button7 := button_quiet{}
        Button7.OnClick().Subscribe(Add7)
        Button8 := button_quiet{}
        Button8.OnClick().Subscribe(Add8)
        Button9 := button_quiet{}
        Button9.OnClick().Subscribe(Add9)
        ButtonBack := button_quiet{}
        ButtonBack.OnClick().Subscribe(DeleteLastChar)
        ButtonEnter := button_quiet{}
        ButtonEnter.OnClick().Subscribe(EnterFunc)
        ButtonClose := button_quiet{}
        ButtonClose.OnClick().Subscribe(CloseFunc)
        
        # Button labels
        Text0 := text_block{DefaultText:=S2M("0"), DefaultTextColor:=ButtonTextColor, DefaultJustification:=text_justification.Center}
        Text1 := text_block{DefaultText:=S2M("1"), DefaultTextColor:=ButtonTextColor, DefaultJustification:=text_justification.Center}
        Text2 := text_block{DefaultText:=S2M("2"), DefaultTextColor:=ButtonTextColor, DefaultJustification:=text_justification.Center}
        Text3 := text_block{DefaultText:=S2M("3"), DefaultTextColor:=ButtonTextColor, DefaultJustification:=text_justification.Center}
        Text4 := text_block{DefaultText:=S2M("4"), DefaultTextColor:=ButtonTextColor, DefaultJustification:=text_justification.Center}
        Text5 := text_block{DefaultText:=S2M("5"), DefaultTextColor:=ButtonTextColor, DefaultJustification:=text_justification.Center}
        Text6 := text_block{DefaultText:=S2M("6"), DefaultTextColor:=ButtonTextColor, DefaultJustification:=text_justification.Center}
        Text7 := text_block{DefaultText:=S2M("7"), DefaultTextColor:=ButtonTextColor, DefaultJustification:=text_justification.Center}
        Text8 := text_block{DefaultText:=S2M("8"), DefaultTextColor:=ButtonTextColor, DefaultJustification:=text_justification.Center}
        Text9 := text_block{DefaultText:=S2M("9"), DefaultTextColor:=ButtonTextColor, DefaultJustification:=text_justification.Center}
        TextBack := text_block{DefaultText:=S2M("←"), DefaultTextColor:=ButtonTextColor, DefaultJustification:=text_justification.Center}
        TextEnter := text_block{DefaultText:=S2M("✔"), DefaultTextColor:=ButtonTextColor, DefaultJustification:=text_justification.Center}
        TextClose := text_block{DefaultText:=S2M("✖"), DefaultTextColor:=color{R:=1.0,G:=1.0,B:=1.0}, DefaultJustification:=text_justification.Center} # Updated icon
        
        # Text display for PIN
        NumTB := text_block{
            DefaultText:=S2M(""),
            DefaultTextColor:=DisplayTextColor,
            DefaultJustification:=text_justification.Center
        }

        MyCanvas := canvas:
            Slots:=array:
                canvas_slot:
                    Anchors:=anchors{Minimum:=vector2{X:=0.5,Y:=0.5},Maximum:=vector2{X:=0.5,Y:=0.5}}
                    Alignment:=vector2{X:=0.5,Y:=0.5}
                    SizeToContent:=true
                    Widget:=overlay:
                        Slots:=array:
                            # Main panel background
                            overlay_slot:
                                Widget:=color_block{DefaultColor:=PanelColor, DefaultDesiredSize:=vector2{X:=UIWidth, Y:=UIHeight}}
                            
                            # Close button positioned at top-right corner
                            overlay_slot:
                                Widget:=CreateButton(ButtonClose, ButtonCloseColor, TextClose, 45.0, 45.0)
                                HorizontalAlignment:=horizontal_alignment.Right
                                VerticalAlignment:=vertical_alignment.Top
                                Padding:=margin{Right:=(UIWidth - 20.0 - 45.0), Top:=(UIHeight - 20.0 - 45.0)}
                            
                            # Content
                            overlay_slot:
                                Padding:=margin{Top:=20.0, Left:=20.0, Right:=20.0, Bottom:=20.0}
                                Widget:=stack_box:
                                    Orientation:=orientation.Vertical
                                    Slots:=array:
                                        # Header with title
                                        stack_box_slot:
                                            Padding:=margin{Bottom:=25.0}
                                            Widget:=text_block{
                                                DefaultText:=S2M("PIN CODE"),
                                                DefaultTextColor:=TitleColor,
                                                DefaultJustification:=text_justification.Center
                                            }
                                        
                                        # Display box
                                        stack_box_slot:
                                            Padding:=margin{Bottom:=30.0}
                                            Widget:=overlay:
                                                Slots:=array:
                                                    overlay_slot:
                                                        Widget:=color_block{DefaultColor:=DisplayBackgroundColor, DefaultDesiredSize:=vector2{X:=360.0, Y:=60.0}}
                                                    overlay_slot:
                                                        Widget:=NumTB
                                                        HorizontalAlignment:=horizontal_alignment.Center
                                                        VerticalAlignment:=vertical_alignment.Center
                                        
                                        # Buttons 1-3
                                        stack_box_slot:
                                            HorizontalAlignment:=horizontal_alignment.Center
                                            Padding:=margin{Bottom:=18.0}
                                            Widget:=stack_box:
                                                Orientation:=orientation.Horizontal
                                                Slots:=array:
                                                    stack_box_slot:
                                                        Widget:=CreateButton(Button1, ButtonColor, Text1, ButtonWidth, ButtonHeight)
                                                    stack_box_slot:
                                                        Padding:=margin{Left:=18.0, Right:=18.0}
                                                        Widget:=CreateButton(Button2, ButtonColor, Text2, ButtonWidth, ButtonHeight)
                                                    stack_box_slot:
                                                        Widget:=CreateButton(Button3, ButtonColor, Text3, ButtonWidth, ButtonHeight)
                                        
                                        # Buttons 4-6
                                        stack_box_slot:
                                            HorizontalAlignment:=horizontal_alignment.Center
                                            Padding:=margin{Bottom:=18.0}
                                            Widget:=stack_box:
                                                Orientation:=orientation.Horizontal
                                                Slots:=array:
                                                    stack_box_slot:
                                                        Widget:=CreateButton(Button4, ButtonColor, Text4, ButtonWidth, ButtonHeight)
                                                    stack_box_slot:
                                                        Padding:=margin{Left:=18.0, Right:=18.0}
                                                        Widget:=CreateButton(Button5, ButtonColor, Text5, ButtonWidth, ButtonHeight)
                                                    stack_box_slot:
                                                        Widget:=CreateButton(Button6, ButtonColor, Text6, ButtonWidth, ButtonHeight)
                                        
                                        # Buttons 7-9
                                        stack_box_slot:
                                            HorizontalAlignment:=horizontal_alignment.Center
                                            Padding:=margin{Bottom:=18.0}
                                            Widget:=stack_box:
                                                Orientation:=orientation.Horizontal
                                                Slots:=array:
                                                    stack_box_slot:
                                                        Widget:=CreateButton(Button7, ButtonColor, Text7, ButtonWidth, ButtonHeight)
                                                    stack_box_slot:
                                                        Padding:=margin{Left:=18.0, Right:=18.0}
                                                        Widget:=CreateButton(Button8, ButtonColor, Text8, ButtonWidth, ButtonHeight)
                                                    stack_box_slot:
                                                        Widget:=CreateButton(Button9, ButtonColor, Text9, ButtonWidth, ButtonHeight)
                                        
                                        # Bottom row: Back, 0, Enter
                                        stack_box_slot:
                                            HorizontalAlignment:=horizontal_alignment.Center
                                            Widget:=stack_box:
                                                Orientation:=orientation.Horizontal
                                                Slots:=array:
                                                    stack_box_slot:
                                                        Widget:=CreateButton(ButtonBack, ButtonBackColor, TextBack, ButtonWidth, ButtonHeight)
                                                    stack_box_slot:
                                                        Padding:=margin{Left:=18.0, Right:=18.0}
                                                        Widget:=CreateButton(Button0, Button0Color, Text0, ButtonWidth, ButtonHeight)
                                                    stack_box_slot:
                                                        Widget:=CreateButton(ButtonEnter, ButtonEnterColor, TextEnter, ButtonWidth, ButtonHeight)

        return (MyCanvas, NumTB)

    Add0(WM:widget_message):void=AddNum(0,WM)
    Add1(WM:widget_message):void=AddNum(1,WM)
    Add2(WM:widget_message):void=AddNum(2,WM)
    Add3(WM:widget_message):void=AddNum(3,WM)
    Add4(WM:widget_message):void=AddNum(4,WM)
    Add5(WM:widget_message):void=AddNum(5,WM)
    Add6(WM:widget_message):void=AddNum(6,WM)
    Add7(WM:widget_message):void=AddNum(7,WM)
    Add8(WM:widget_message):void=AddNum(8,WM)
    Add9(WM:widget_message):void=AddNum(9,WM)

    CloseFunc(WM:widget_message):void=
        RemovePinPad(WM.Player)

    EnterFunc(WM:widget_message):void=
        Print("Enter")
        if(Stuff:=StuffPerAgent[WM.Player]?):
            for(PS:Passcodes):
                PasscodeString:="{PS.PIN}"
                if(PasscodeString=Stuff(2)):
                    if(InnerTrigger:=PS.SuccessTrigger?):
                        InnerTrigger.Trigger(WM.Player)
                    else:
                        SuccessTrigger.Trigger(WM.Player)
                    RemovePinPad(WM.Player)
                    return

        FailTrigger.Trigger(WM.Player)
        RemovePinPad(WM.Player)

    AddNum(Num:int,WM:widget_message):void=
        if(Stuff:=StuffPerAgent[WM.Player]?):
            var String:string=Stuff(2)
            # Check if the current length is less than the maximum allowed
            if(String.Length < MaxInputLength):
                set String += "{Num}"
                if(set StuffPerAgent[WM.Player] = option{(Stuff(0),Stuff(1),String)}){}
                UpdateUI(WM)

    UpdateUI(WM:widget_message):void=
        if(Stuff:=StuffPerAgent[WM.Player]?):
            var String:string=Stuff(2)
            TB:=Stuff(1)
            TB.SetText(S2M("{String}"))

    DeleteLastChar(WM:widget_message):void=
        if(Stuff:=StuffPerAgent[WM.Player]?):
            var String: string = Stuff(2)
            var UpdatedString : string = ""
            for(Index->S:String):
                if(Index = String.Length-1):
                    # This the last character, remove it
                else:
                    set UpdatedString += "{S}"
            if(set StuffPerAgent[WM.Player] = option{(Stuff(0),Stuff(1),UpdatedString)}){}
            UpdateUI(WM)