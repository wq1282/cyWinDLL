VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cyDebugEx"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True

Public Sub cySort_STRING(ByRef strArray() As String, Optional ByVal blnDecending As Boolean = False)
   
   Dim strTempVal  As String
   Dim lngCounter  As Long
   Dim lngGapSize  As Long
   Dim lngCurPos   As Long
   Dim lngFirstRow As Long
   Dim lngLastRow  As Long
   Dim lngNumRows  As Long
   
   lngFirstRow = LBound(strArray)
   lngLastRow = UBound(strArray)
   lngNumRows = lngLastRow - lngFirstRow + 1
   
   Do
      lngGapSize = lngGapSize * 3 + 1
   Loop Until lngGapSize > lngNumRows
   
   Do
      lngGapSize = lngGapSize \ 3
      For lngCounter = (lngGapSize + lngFirstRow) To lngLastRow
         lngCurPos = lngCounter
         strTempVal = strArray(lngCounter)
         Do While CompareResult_TXT(strArray(lngCurPos - lngGapSize), strTempVal, blnDecending)
            strArray(lngCurPos) = strArray(lngCurPos - lngGapSize)
            lngCurPos = lngCurPos - lngGapSize
            If (lngCurPos - lngGapSize) < lngFirstRow Then Exit Do
         Loop
         strArray(lngCurPos) = strTempVal
      Next
   Loop Until lngGapSize = 1
   
End Sub

' (See documentation for the "Sort_STRING" function)
Public Sub cySort_BYTE(ByRef bytArray() As Byte, Optional ByVal blnDecending As Boolean = False)
   
   Dim strTempVal  As String
   Dim lngCounter  As Long
   Dim lngGapSize  As Long
   Dim lngCurPos   As Long
   Dim lngFirstRow As Long
   Dim lngLastRow  As Long
   Dim lngNumRows  As Long
   
   lngFirstRow = LBound(bytArray)
   lngLastRow = UBound(bytArray)
   lngNumRows = lngLastRow - lngFirstRow + 1
   
   Do
      lngGapSize = lngGapSize * 3 + 1
   Loop Until lngGapSize > lngNumRows
   
   Do
      lngGapSize = lngGapSize \ 3
      For lngCounter = (lngGapSize + lngFirstRow) To lngLastRow
         lngCurPos = lngCounter
         strTempVal = bytArray(lngCounter)
         Do While CompareResult_NUM(bytArray(lngCurPos - lngGapSize), strTempVal, blnDecending)
            bytArray(lngCurPos) = bytArray(lngCurPos - lngGapSize)
            lngCurPos = lngCurPos - lngGapSize
            If (lngCurPos - lngGapSize) < lngFirstRow Then Exit Do
         Loop
         bytArray(lngCurPos) = strTempVal
      Next
   Loop Until lngGapSize = 1
   
End Sub

' (See documentation for the "Sort_STRING" function)
Public Sub cySort_INTEGER(ByRef intArray() As Integer, Optional ByVal blnDecending As Boolean = False)
   
   Dim strTempVal  As String
   Dim lngCounter  As Long
   Dim lngGapSize  As Long
   Dim lngCurPos   As Long
   Dim lngFirstRow As Long
   Dim lngLastRow  As Long
   Dim lngNumRows  As Long
   
   lngFirstRow = LBound(intArray)
   lngLastRow = UBound(intArray)
   lngNumRows = lngLastRow - lngFirstRow + 1
   
   Do
      lngGapSize = lngGapSize * 3 + 1
   Loop Until lngGapSize > lngNumRows
   
   Do
      lngGapSize = lngGapSize \ 3
      For lngCounter = (lngGapSize + lngFirstRow) To lngLastRow
         lngCurPos = lngCounter
         strTempVal = intArray(lngCounter)
         Do While CompareResult_NUM(intArray(lngCurPos - lngGapSize), strTempVal, blnDecending)
            intArray(lngCurPos) = intArray(lngCurPos - lngGapSize)
            lngCurPos = lngCurPos - lngGapSize
            If (lngCurPos - lngGapSize) < lngFirstRow Then Exit Do
         Loop
         intArray(lngCurPos) = strTempVal
      Next
   Loop Until lngGapSize = 1
   
End Sub

' (See documentation for the "Sort_STRING" function)
Public Sub cySort_LONG(ByRef lngArray() As Long, Optional ByVal blnDecending As Boolean = False)
   
   Dim strTempVal  As String
   Dim lngCounter  As Long
   Dim lngGapSize  As Long
   Dim lngCurPos   As Long
   Dim lngFirstRow As Long
   Dim lngLastRow  As Long
   Dim lngNumRows  As Long
   
   lngFirstRow = LBound(lngArray)
   lngLastRow = UBound(lngArray)
   lngNumRows = lngLastRow - lngFirstRow + 1
   
   Do
      lngGapSize = lngGapSize * 3 + 1
   Loop Until lngGapSize > lngNumRows
   
   Do
      lngGapSize = lngGapSize \ 3
      For lngCounter = (lngGapSize + lngFirstRow) To lngLastRow
         lngCurPos = lngCounter
         strTempVal = lngArray(lngCounter)
         Do While CompareResult_NUM(lngArray(lngCurPos - lngGapSize), strTempVal, blnDecending)
            lngArray(lngCurPos) = lngArray(lngCurPos - lngGapSize)
            lngCurPos = lngCurPos - lngGapSize
            If (lngCurPos - lngGapSize) < lngFirstRow Then Exit Do
         Loop
         lngArray(lngCurPos) = strTempVal
      Next
   Loop Until lngGapSize = 1
   
End Sub

' (See documentation for the "Sort_STRING" function)
Public Sub cySort_SINGLE(ByRef sngArray() As Single, Optional ByVal blnDecending As Boolean = False)
   
   Dim strTempVal  As String
   Dim lngCounter  As Long
   Dim lngGapSize  As Long
   Dim lngCurPos   As Long
   Dim lngFirstRow As Long
   Dim lngLastRow  As Long
   Dim lngNumRows  As Long
   
   lngFirstRow = LBound(sngArray)
   lngLastRow = UBound(sngArray)
   lngNumRows = lngLastRow - lngFirstRow + 1
   
   Do
      lngGapSize = lngGapSize * 3 + 1
   Loop Until lngGapSize > lngNumRows
   
   Do
      lngGapSize = lngGapSize \ 3
      For lngCounter = (lngGapSize + lngFirstRow) To lngLastRow
         lngCurPos = lngCounter
         strTempVal = sngArray(lngCounter)
         Do While CompareResult_NUM(sngArray(lngCurPos - lngGapSize), strTempVal, blnDecending)
            sngArray(lngCurPos) = sngArray(lngCurPos - lngGapSize)
            lngCurPos = lngCurPos - lngGapSize
            If (lngCurPos - lngGapSize) < lngFirstRow Then Exit Do
         Loop
         sngArray(lngCurPos) = strTempVal
      Next
   Loop Until lngGapSize = 1
   
End Sub

' (See documentation for the "Sort_STRING" function)
Public Sub cySort_DOUBLE(ByRef dblArray() As Double, Optional ByVal blnDecending As Boolean = False)
   
   Dim strTempVal  As String
   Dim lngCounter  As Long
   Dim lngGapSize  As Long
   Dim lngCurPos   As Long
   Dim lngFirstRow As Long
   Dim lngLastRow  As Long
   Dim lngNumRows  As Long
   
   lngFirstRow = LBound(dblArray)
   lngLastRow = UBound(dblArray)
   lngNumRows = lngLastRow - lngFirstRow + 1
   
   Do
      lngGapSize = lngGapSize * 3 + 1
   Loop Until lngGapSize > lngNumRows
   
   Do
      lngGapSize = lngGapSize \ 3
      For lngCounter = (lngGapSize + lngFirstRow) To lngLastRow
         lngCurPos = lngCounter
         strTempVal = dblArray(lngCounter)
         Do While CompareResult_NUM(dblArray(lngCurPos - lngGapSize), strTempVal, blnDecending)
            dblArray(lngCurPos) = dblArray(lngCurPos - lngGapSize)
            lngCurPos = lngCurPos - lngGapSize
            If (lngCurPos - lngGapSize) < lngFirstRow Then Exit Do
         Loop
         dblArray(lngCurPos) = strTempVal
      Next
   Loop Until lngGapSize = 1
   
End Sub

' (See documentation for the "Sort_STRING" function)
Public Sub cySort_DATE(ByRef datArray() As Double, Optional ByVal blnDecending As Boolean = False)
   
   Dim strTempVal  As String
   Dim lngCounter  As Long
   Dim lngGapSize  As Long
   Dim lngCurPos   As Long
   Dim lngFirstRow As Long
   Dim lngLastRow  As Long
   Dim lngNumRows  As Long
   
   lngFirstRow = LBound(datArray)
   lngLastRow = UBound(datArray)
   lngNumRows = lngLastRow - lngFirstRow + 1
   
   Do
      lngGapSize = lngGapSize * 3 + 1
   Loop Until lngGapSize > lngNumRows
   
   Do
      lngGapSize = lngGapSize \ 3
      For lngCounter = (lngGapSize + lngFirstRow) To lngLastRow
         lngCurPos = lngCounter
         strTempVal = datArray(lngCounter)
         Do While CompareResult_DAT(datArray(lngCurPos - lngGapSize), strTempVal, blnDecending)
            datArray(lngCurPos) = datArray(lngCurPos - lngGapSize)
            lngCurPos = lngCurPos - lngGapSize
            If (lngCurPos - lngGapSize) < lngFirstRow Then Exit Do
         Loop
         datArray(lngCurPos) = strTempVal
      Next
   Loop Until lngGapSize = 1
   
End Sub

' This function is used within this module only to compare values
Private Function CompareResult_TXT(ByVal strValue1 As String, ByVal strValue2 As String, Optional blnDescending As Boolean = False) As Boolean
   CompareResult_TXT = CBool(StrComp(strValue1, strValue2, vbTextCompare) = 1)
   CompareResult_TXT = CompareResult_TXT Xor blnDescending
End Function

' This function is used within this module only to compare values
Private Function CompareResult_NUM(ByVal dblValue1 As Double, ByVal dblValue2 As Double, Optional blnDescending As Boolean = False) As Boolean
   CompareResult_NUM = CBool(dblValue1 > dblValue2)
   CompareResult_NUM = CompareResult_NUM Xor blnDescending
End Function

' This function is used within this module only to compare values
Private Function CompareResult_DAT(ByVal datValue1 As Date, ByVal datValue2 As Date, Optional blnDescending As Boolean = False) As Boolean
   CompareResult_DAT = CBool(datValue1 > datValue2)
   CompareResult_DAT = CompareResult_DAT Xor blnDescending
End Function

'��������:cyShowDB
'���ã���ʾ���ݿ�����ݼ�
'===========================================================
'����ʱ�䣺2006-8-26 12:58
'  ������
'===========================================================
Sub cyShowDB()

End Sub

'��������:cyShowHwnd

'���ã���ʾ�����ⴰ��

'##################################################
'����ʱ�䣺2004-2-11 15:51:43
'  ������
'##################################################
'  ����
Sub cyShowHwnd()
    frmDebugHwnd.Show
End Sub

'��������:cyListArrayString

'���ã����ַ���������ʾ���б���

'##################################################
'����ʱ�䣺2004-2-11 15:48:58
'  ������
'   sArray(                 --�ַ���������
'##################################################
'  ����
Sub cyListArrayString(sArray() As String)
    On Error Resume Next
    frmDebug.sDebugType = "ListArrayString"
    frmDebug.Show
    frmDebug.List1.Clear
    Dim i As Long
    For i = LBound(sArray) To UBound(sArray)
        frmDebug.List1.AddItem i & vbTab & "|" & vbTab & sArray(i) ' & vbTab & Hex(Asc(Mid(sString, i, 1)))
    Next
    frmDebug.lblCount(0) = "����������" & UBound(sArray) - LBound(sArray) + 1
End Sub

'���ã����ֽ���������ʾ���б���

'##################################################
'����ʱ�䣺2004-2-11 15:48:58
'  ������
'   sArray(                 --�ֽ�������
'##################################################
'  ����
Sub cyListArrayByte(sArray() As Byte)
On Error Resume Next
    frmDebug.sDebugType = "ListArrayByte"

    frmDebug.List1.Clear
    frmDebug.Show
    Dim i As Long
    For i = LBound(sArray) To UBound(sArray)
        frmDebug.List1.AddItem i & vbTab & "|" & vbTab & sArray(i) & vbTab & "&H" & Hex(sArray(i)) '& vbTab & IIf(i Mod 2 = 1, Chr(CLng("&H" & Hex(sArray(i)) & Hex(sArray(i - 1)))), "")
    Next
    frmDebug.lblCount(0) = "����������" & UBound(sArray) - LBound(sArray) + 1
End Sub
Sub cyListArrayLong(sArray() As Long)
On Error Resume Next
    frmDebug.sDebugType = "ListArrayLong"
    
    frmDebug.List1.Clear
    Dim i As Long
    For i = LBound(sArray) To UBound(sArray)
        frmDebug.List1.AddItem i & vbTab & "|" & vbTab & sArray(i)
    Next
    frmDebug.lblCount(0) = "����������" & UBound(sArray) - LBound(sArray) + 1
    frmDebug.Show
End Sub
Sub cyListArrayInteger(sArray() As Integer)
On Error Resume Next
    frmDebug.sDebugType = "ListArrayInteger"
    
    frmDebug.List1.Clear
    Dim i As Long
    For i = LBound(sArray) To UBound(sArray)
        frmDebug.List1.AddItem i & vbTab & "|" & vbTab & sArray(i) & vbTab & Hex(Asc(Mid(sString, i, 1)))
    Next
    frmDebug.lblCount(0) = "����������" & UBound(sArray) - LBound(sArray) + 1
    frmDebug.Show
End Sub

'��������:cyReleaseGetHardDiskSN

'���ã��ͷŻ�ȡӲ��ID��DLL�ļ�

'##################################################
'����ʱ�䣺2004-2-11 15:56:16
'  ������
'   sPath As String         --
'##################################################
'  ����
Sub cyReleaseGetHardDiskSN(Optional sPath As String)
Dim F As New cyFileEx
    '�����δע���࣬������DLL��ע��
    Dim bArray() As Byte
    bArray = LoadResData(101, "CUSTOM") '���Զ�����Դ��101����Դ��������OCX
    Open IIf(sPath = "", F.cyUnitePathFileName(App.Path, "GetHDSN.dat"), F.cyUnitePathFileName(sPath, "GetHDSN.dat")) For Binary As #1
        Seek #1, 1
        Put #1, , bArray
    Close #1
End Sub

'��������:cyAppearString

'���ã����ַ��������г���

'##################################################
'����ʱ�䣺2004-2-11 15:56:50
'  ������
'   sString As String       --
'##################################################
'  ����
Sub cyAppearString(ByVal sString As String)

    frmDebug.sDebugType = "AppearString"

    frmDebug.List1.Clear
    Dim i As Long: Dim iLen As Long
    iLen = Len(sString)
    For i = 1 To iLen
        frmDebug.List1.AddItem i & vbTab & "|" & vbTab & Mid(sString, i, 1) & vbTab & Asc(Mid(sString, i, 1)) & vbTab & Hex(Asc(Mid(sString, i, 1)))
    Next
    frmDebug.lblCount(0) = "�ַ������ȣ�" & iLen
    frmDebug.txtString = sString
    frmDebug.Show
End Sub

Sub cyAppearRs(Rs As Recordset)

    
End Sub
''
'''����������ظ���ֵ,�����ظ�����
''Sub cyArrayKillDuplicate(ByRef sArray() As String)
''On Error GoTo Err
''    Dim sNewArray() As String
''    Dim iCount As Long  '��¼ѭ��ֵ�ı���
''    ReDim sNewArray(0)
''    sNewArray(0) = sArray(0)
''    For i = 1 To UBound(sArray)
''        For j = 0 To UBound(sNewArray)
''            If UCase(sArray(i)) = UCase(sNewArray(j)) Then GoTo Pass
''        Next
''        iCount = iCount + 1
''        ReDim Preserve sNewArray(iCount)
''        sNewArray(iCount) = sArray(i)
''Pass:   '�������ͬ��������һ��ѭ��,����д������
''    Next
''    '��������
''    sArray = sNewArray
''    Exit Sub
''Err:
''End Sub
'
'��������:cyGetControlsPos
'���ã���ö��������пؼ���λ����Ϣ
'===========================================================
'����ʱ�䣺2006-12-31 11:55
'  ������
'           frmWnd --  ����ÿؼ�λ����Ϣ�Ĵ���

'  ���ӣ�        dBug.cyGetControlsPos Me

'  �����
'Name:Picture1 Left:0        Top:45        Width:4155    Height:2880
'Name:Command1 Left:840      Top:300       Width:735     Height:570
'Name:Text1    Left:1770     Top:390       Width:1365    Height:465
'Name:Check1   Left:600      Top:1245      Width:750     Height:435
'Name:Option1  Left:1755     Top:1455      Width:1365    Height:240
'Name:List1    Left:120      Top:1905      Width:1215    Height:780
'Name:Combo1   Left:1590     Top:2055      Width:975     Height:300
'Name:HScroll1 Left:2850     Top:1830      Width:900     Height:555
'Name:Picture2 Left:4425     Top:0         Width:2670    Height:2655
'Name:Drive1   Left:420      Top:315       Width:1095    Height:300
'Name:Picture3 Left:405      Top:1725      Width:975     Height:420
'Name:Text2    Left:1665     Top:900       Width:750     Height:315
'Name:Dir1     Left:1665     Top:1650      Width:645     Height:720
'Name:Label2   Left:540      Top:1035      Width:1230    Height:420

'===========================================================
'Sub cyGetControlsPos(ByVal frmWnd As Object)
'Dim objControl As Object
'For Each objControl In frmWnd.Controls
'    Debug.Print "Name:" & objControl.name, "Left:" & objControl.Left, "Top:" & objControl.Top, "Width:" & objControl.Width, "Height:" & objControl.Height
'
'Next
'
'End Sub