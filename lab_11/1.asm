; DialogBox example

format PE GUI 4.0
entry start

include 'win32a.inc'

ID_CAPTION         = 101
ID_MESSAGE         = 102
ID_RESULT          = 103
ID_ICONERROR       = 201



section '.text' code readable executable

  start:

        invoke  GetModuleHandle,0
        invoke  DialogBoxParam,eax,37,HWND_DESKTOP,DialogProc,0
        or      eax,eax
        jz      exit
        invoke  MessageBox,HWND_DESKTOP,message,caption,[flags]
  exit:
        invoke  ExitProcess,0

proc DialogProc hwnddlg,msg,wparam,lparam
        push    ebx esi edi
        cmp     [msg],WM_COMMAND
        je      .wmcommand
        cmp     [msg],WM_CLOSE
        je      .wmclose
        xor     eax,eax
        jmp     .finish
  .wmcommand:
        cmp     [wparam],BN_CLICKED shl 16 + IDOK
        jne     .processed
        invoke  GetDlgItemInt,[hwnddlg],ID_CAPTION,NULL,FALSE
        mov ebx, eax
        invoke  GetDlgItemInt,[hwnddlg],ID_MESSAGE,NULL,FALSE


        add al, bl
        add al, "0"
        cmp al, "9"
        ja .convert
        mov [result], al
        invoke SendMessage,[hwnddlg],WM_CLEAR, ID_RESULT, 0
        ;invoke  RemoveProp, [hwnddlg],ID_RESULT
        invoke  SetDlgItemText,[hwnddlg],ID_RESULT,result
        jmp .processed
      .convert:
        mov dl, al
        mov bl, 10
        sub dl, bl
        mov al, dl
        mov [number + 1], al
        mov [number + 0], "1"
       ; mov [result], al
        ;invoke  RemoveProp, [hwnddlg],ID_RESULT
        invoke  SetDlgItemText,[hwnddlg],ID_RESULT,number

      .topmost_ok:
        invoke  EndDialog, result,1
        jmp     .processed
  .wmclose:
        invoke  EndDialog,[hwnddlg],0
  .processed:
        mov     eax,1

  .finish:
        pop     edi esi ebx
        ret
endp

section '.bss' readable writeable

  flags dd ?
  caption rb 1
  message rb 1
  result db 2  dup(0), '$'
  number db 3 dup(0), '$'


section '.idata' import data readable writeable

  library kernel,'KERNEL32.DLL',\
          user,'USER32.DLL'

  import kernel,\
         GetModuleHandle,'GetModuleHandleA',\
         ExitProcess,'ExitProcess'

  import user,\
         DialogBoxParam,'DialogBoxParamA',\
         CheckRadioButton,'CheckRadioButton',\
         GetDlgItemInt,'GetDlgItemInt',\
         SetDlgItemText,'SetDlgItemTextA',\
         SendMessage, 'SendMessageA', \
         IsDlgButtonChecked,'IsDlgButtonChecked',\
         MessageBox,'MessageBoxA',\
         EndDialog,'EndDialog'

section '.rsrc' resource data readable

  directory RT_DIALOG,dialogs

  resource dialogs,\
           37,LANG_ENGLISH+SUBLANG_DEFAULT,demonstration

  dialog demonstration,'Create message box',70,70,190,90,WS_CAPTION+WS_POPUP+WS_SYSMENU+DS_MODALFRAME
    dialogitem 'STATIC','&+',-1,42,20,10,8,WS_VISIBLE
    dialogitem 'EDIT','',ID_CAPTION,10,20,30,13,WS_VISIBLE+WS_BORDER+WS_TABSTOP
    dialogitem 'STATIC','&Calculation:',-1,10,10,70,8,WS_VISIBLE
    dialogitem 'EDIT','',ID_MESSAGE,50,20, 30,13,WS_VISIBLE+WS_BORDER+WS_TABSTOP+ES_AUTOHSCROLL
    dialogitem 'STATIC','&=',-1,82,20,10,8,WS_VISIBLE
    dialogitem 'EDIT','',ID_RESULT,90,20,60,13,WS_VISIBLE+WS_BORDER+WS_TABSTOP+ES_AUTOHSCROLL
    dialogitem 'BUTTON','Get result',IDOK,90,40,60,15,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON
  enddialog