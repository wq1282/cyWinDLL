VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cyDataBaseEx"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Dim cmd As New Command

Enum ExportType
    Export2FoxPro = 1
    Export2Excel = 2
    Export2HTML = 4
    Export2Text = 5
End Enum

Enum DefaultReturnType
    ReturnString = 0
    ReturnLong = 1
    ReturnCurency = 2
End Enum

'-----------------------------------------------------------------------------
'��ȡ��ǰ���õķ������б�
'-----------------------------------------------------------------------------
Private Const SQL_NEED_DATA As Long = 99&
Private Const SQL_SUCCESS As Long = 0&
Private Declare Function SQLAllocConnect Lib "odbc32.dll" (ByVal henv As Long, phdbc As Long) As Integer
Private Declare Function SQLAllocEnv Lib "odbc32.dll" (phenv As Long) As Integer
Private Declare Function SQLBrowseConnect Lib "odbc32.dll" (ByVal hdbc As Long, ByVal szConnStrIn As String, ByVal cbConnStrIn As Integer, ByVal szConnStrOut As String, ByVal cbConnStrOutMax As Integer, pcbconnstrout As Integer) As Integer
Private Declare Function SQLDisconnect Lib "odbc32.dll" (ByVal hdbc As Long) As Integer
Private Declare Function SQLFreeConnect Lib "odbc32.dll" (ByVal hdbc As Long) As Integer
Private Declare Function SQLFreeEnv Lib "odbc32.dll" (ByVal henv As Long) As Integer
'-----------------------------------------------------------------------------
'��ȡ��ǰ���õķ������б�
'-----------------------------------------------------------------------------

'-----------------------------------------------------------------------------
'�����ݼ�������ļ�������
'-----------------------------------------------------------------------------
Enum RsToFileType
    BinaryFile = 0
    XmlFile = 1
End Enum
'-----------------------------------------------------------------------------
'�����ݼ�������ļ�������
'-----------------------------------------------------------------------------

'����һ�����̼������ݿ�����
Dim Cn As New ADODB.Connection

'����������ݿ��������
Dim sConnectString As String

'��õ�ǰ����
Public Function cyGetConnection() As Connection
    Set cyGetConnection = Cn
    
End Function

'��������
Public Function cySetConnection(ByRef Conn As Connection)
    Set Cn = Conn

End Function

'ȡ��������
Public Static Property Get ConnectString() As String
    ConnectString = sConnectString
End Property

'д��������
Public Static Property Let ConnectString(ByVal vNewValue As String)
    sConnectString = vNewValue
End Property

Public Sub cyConnectSqlServer(ByVal sServer As String, ByVal sDataBase As String, Optional ByVal sID As String, Optional ByVal sPassWord As String, Optional ByVal iConnectTimeOut As Byte = 5, Optional ByVal iCommandTimeOut As Byte = 5)
    Screen.MousePointer = 13
    '��������Ѵ򿪣����ȹرյ�ǰ����
    If Cn.State = adStateOpen Then Cn.Close
    If sID = "" Then
    '�������ʱ���ṩ�û�������WINDOWS��֤��ʽ��������
        sConnectString = "Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=" & sDataBase & ";Data Source=" & sServer
    Else
    '�����Ա�׼SQL��֤��ʽ��������
        sConnectString = "driver={SQL server};server=" & sServer & ";uid=" & sID & ";pwd=" & sPassWord & ";database=" & sDataBase & ";timeout=5;"
    End If
    '�������ݿ������
    Cn.ConnectionTimeout = iConnectTimeOut
    Cn.CommandTimeout = iCommandTimeOut
    Cn.Open sConnectString
    Screen.MousePointer = 0
    
End Sub

'    D.cyConnectAccess "C:\Documents and Settings\cy\����\����[ͳ�Ʋ���]\����[ͳ�Ʋ���]\dbsalesta.mdb", "DbRetail0423"
Public Sub cyConnectAccess(ByVal sDataBaseFileName As String, Optional ByVal sDataBasePassWord As String, Optional ByVal sGroupUserName As String, Optional ByVal sGroupPassWord As String)
Screen.MousePointer = 13
    '��������Ѵ򿪣����ȹرյ�ǰ����
    If Cn.State = adStateOpen Then Cn.Close
    If sGroupUserName <> "" Then
    '����ṩ�˹������ʺ���֤�����Թ����鷽ʽ��������
        sConnectString = "Provider=Microsoft.Jet.OLEDB.4.0;User ID=" + sGroupUserName + ";Password=" & sGroupPassWord & ";Data Source=" + sDataBaseFileName + ";Persist Security Info=False"
    Else
    '��������ͨ��ʽ�������ݿ⣨����ṩ�����ݿ�������������ݿ�����������ӣ�
        sConnectString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + sDataBaseFileName + ";" + IIf(sDataBasePassWord <> "", "Jet OLEDB:Database Password=" + sDataBasePassWord, "")
    End If
    '�������ݿ������
    Cn.Open sConnectString
Screen.MousePointer = 0
End Sub

'���´�����
Sub cyCnOpen()
    '��������ѹر������´�����
    If Not Cn.State = adStateOpen Then Cn.Open sConnectString
End Sub

'�ر�����
Sub cyCnClose()
    '��������Ѵ���رմ����Ӳ��ͷ���ռ�õ���Դ
    If Cn.State = adStateOpen Then
        Cn.Close
        Set Cn = Nothing
    End If
End Sub

'    Set Rs = D.cyGetRs("select * from tblUser")
'�������ṩ��SQL��䷵�����ݼ�
Function cyGetRs(ByVal sSQL As String) As Recordset
Screen.MousePointer = 13
    Dim Rs As Recordset
    Set Rs = New ADODB.Recordset
    Rs.CursorLocation = adUseClient
    Rs.Open sSQL, Cn, adOpenKeyset, adLockOptimistic, adCmdText
    Set cyGetRs = Rs
Screen.MousePointer = 0
End Function

'Set Rs = D.cyGetSQLUsersNameToRs("(local)", "sa")
Function cyGetSQLUsersNameToRs(ByVal sServer As String, Optional ByVal sID As String, Optional ByVal sPassWord As String) As Recordset
Screen.MousePointer = 13
    
    '��������Ѵ򿪣����ȹرյ�ǰ����
    If Cn.State = adStateOpen Then Cn.Close
    If sID = "" Then
    '�������ʱ���ṩ�û�������WINDOWS��֤��ʽ��������
        sConnectString = "Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=master;Data Source=" & sServer
    Else
    '�����Ա�׼SQL��֤��ʽ��������
        sConnectString = "Provider=SQLOLEDB.1;Persist Security Info=False;User ID=" & sID & ";PassWord=" & sPassWord & ";Initial Catalog=master;Data Source=" & sServer
    End If
    '�������ݿ������
    Cn.Open sConnectString
    '�������ݿ���
    Set cyGetSQLUsersNameToRs = cyGetRs("SELECT name FROM sysxlogins")
    
Screen.MousePointer = 0
End Function

'ȡ��SQL���������������ݿ�
Function cyGetSQLDataBaseNameToRs(ByVal sServer As String, Optional ByVal sID As String, Optional ByVal sPassWord As String) As Recordset
Screen.MousePointer = 13
    '��������Ѵ򿪣����ȹرյ�ǰ����
    If Cn.State = adStateOpen Then Cn.Close
    If sID = "" Then
    '�������ʱ���ṩ�û�������WINDOWS��֤��ʽ��������
        sConnectString = "Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=master;Data Source=" & sServer
    Else
    '�����Ա�׼SQL��֤��ʽ��������
        sConnectString = "Provider=SQLOLEDB.1;Persist Security Info=False;User ID=" & sID & ";PassWord=" & sPassWord & ";Initial Catalog=master;Data Source=" & sServer
    End If
    '�������ݿ������
    Cn.Open sConnectString
    '�������ݿ���
    Set cyGetSQLDataBaseNameToRs = cyGetRs("SELECT name FROM sysdatabases")
Screen.MousePointer = 0
End Function

'�������пɼ�⵽��SQL������
Function cyGetSQLServerListToRs() As Recordset
Screen.MousePointer = 13
    Dim Rs As New Recordset
    Dim rc As Integer
    Dim henv As Long
    Dim hdbc As Long
    Dim stCon As String
    Dim stConOut As String
    Dim pcbConOut As Integer
    Dim ichBegin As Integer
    Dim ichEnd As Integer
    Dim stOut As String
    Dim sArray() As String
    rc = SQLAllocEnv(henv)
    rc = SQLAllocConnect(ByVal henv, hdbc)
    stCon = "DRIVER=SQL Server"
    
    ' Get the size of the buffer to create and create it
    rc = SQLBrowseConnect(ByVal hdbc, stCon, Len(stCon), stConOut, Len(stConOut) + 2, pcbConOut)
    stConOut = String$(pcbConOut + 2, vbNullChar)
    
    ' Get the actual server list
    rc = SQLBrowseConnect(ByVal hdbc, stCon, Len(stCon), stConOut, Len(stConOut) + 2, pcbConOut)
    
    If (rc <> SQL_SUCCESS) And (rc <> SQL_NEED_DATA) Then
        ' ignore the errors if any occur
    Else
        ' Parse out the server list
        ichBegin = InStr(InStr(1, UCase(stConOut), "SERVER="), stConOut, "{", vbBinaryCompare)
        stOut = Mid$(stConOut, ichBegin + 1)
        ichEnd = InStr(1, stOut, "}", vbBinaryCompare)
        
        sArray = Split(Left$(stOut, ichEnd - 1), ",")
If UBound(sArray) = -1 Then GoTo Pass
        Dim i As Long
        With Rs
            .CursorLocation = adUseClient
            .Fields.Append "Server", adLongVarWChar, 1
            .Open
                For i = 0 To UBound(sArray)
                    .AddNew 0, sArray(i)
                Next
                If Rs.RecordCount > 0 Then Rs.MoveFirst
            Set cyGetSQLServerListToRs = Rs
        End With
        
    End If

Pass:

    ' Disconnect, free the connection handle, then
    ' free the environment handle.
    rc = SQLDisconnect(hdbc)
    rc = SQLFreeConnect(hdbc)
    rc = SQLFreeEnv(henv)
Screen.MousePointer = 0
End Function

'�����Ѵ򿪵����ݿ�����б���
Function cyGetTableNameToRs() As Recordset
Screen.MousePointer = 13
    Dim Rs As Recordset
    
    '״̬Ϊδ��,�򲻷�������
    If Cn.State = 0 Then Exit Function
    
    '���صı����ļ�¼��,���ڷ��صļ�¼����3�� ,ֻ�е�3��������,��˽���һ���µļ�¼��,������д��ȥ
    Set Rs = Cn.OpenSchema(adSchemaTables, Array(Empty, Empty, Empty, "Table"))
    
    Dim RsTmp As New Recordset
    With RsTmp
        .CursorLocation = adUseClient
        '�½�һ��Field������ű���
        .Fields.Append "Table", adLongVarWChar, 1
        '��������ݼ�
        .Open
            Do While Not Rs.EOF
                '���ӱ��������ݼ���
                .AddNew 0, IIf(InStr(1, Rs(2).Value, " ") > 0, "[" + Rs(2).Value + "]", Rs(2).Value)
                Rs.MoveNext
            Loop
            '��ָ���Ƶ���һ����¼
            If RsTmp.RecordCount > 0 Then RsTmp.MoveFirst
        Set cyGetTableNameToRs = RsTmp
    End With
Screen.MousePointer = 0
End Function

Function cyExeCute(ByVal sSQL As String) As Recordset

    If sSQL = "" Then Exit Function
    Dim tmpRs As New Recordset
    Dim cmd As New Command
    Set cmd.ActiveConnection = Cn
    cmd.CommandText = sSQL
    tmpRs.CursorLocation = adUseClient
    Set tmpRs = cmd.Execute(, , adCmdText)
    Set cyExeCute = tmpRs
    
End Function

Public Sub cyRsStoreToFile(Rs As Recordset, sFileName As String, Optional FileType As RsToFileType)
On Error GoTo Err
Screen.MousePointer = 13

     '�����ݼ����浽��ͬ���ļ�������(�����������ļ���XML�ļ�)
    Rs.Save sFileName, FileType
    Screen.MousePointer = 0
    Exit Sub
Err:
'���ļ��Ѿ������
If Err.Number = 58 Then
    On Error Resume Next
    Kill sFileName
    '�����ݼ����浽��ͬ���ļ�������(�����������ļ���XML�ļ�)
    Rs.Save sFileName, FileType
End If
Screen.MousePointer = 0
End Sub

Public Function cyRsGetFromFile(sFileName As String) As Recordset
Screen.MousePointer = 13
    
    Dim Rs As New Recordset 'ע��˴�һ��Ҫ�ӹؼ���New
    '�����ݼ����ļ��ж���
    Rs.Open sFileName, "Provider=MSPersist"
    '�������ݼ�
    Set cyRsGetFromFile = Rs

Screen.MousePointer = 0
End Function

Sub cyFileStoreToDB(sSQL As String, sFileName As String)
Screen.MousePointer = 13

    Dim Rs As Recordset
    '���ļ��������������
    Dim byteArray() As Byte
    ReDim byteArray(FileLen(sFileName) - 1) As Byte
    Open sFileName For Binary As #1
      Get #1, , byteArray
    Close #1
    
    '���������������ӵ����ݼ���
    Set Rs = New ADODB.Recordset
    Rs.CursorLocation = adUseClient
    Rs.Open sSQL, Cn, adOpenKeyset, adLockOptimistic, adCmdText
    Rs.AddNew Rs(0).name, byteArray
    '���²��ر����ݼ�
    Rs.Update
    Rs.Close
    '�ͷ���Դ
    Set Rs = Nothing

Screen.MousePointer = 0
End Sub

Sub cyFileGetFromDB(sSQL As String, sFileName As String)
Screen.MousePointer = 13

    Dim Rs As Recordset
    '����һ������������
    Dim byteArray() As Byte
    '�����ݿ�������ֶ��е�����д�������������
    Set Rs = New ADODB.Recordset
    Rs.CursorLocation = adUseClient
    Rs.Open sSQL, Cn, adOpenKeyset, adLockOptimistic, adCmdText
    byteArray = Rs(0).Value
    '�رղ��ͷ���Դ
    Rs.Close
    Set Rs = Nothing
        
    '������������д�뵽�ļ���
    Open sFileName For Binary As #1
      Put #1, , byteArray
    Close #1

Screen.MousePointer = 0
End Sub

Sub cyMdbBackUp(ByVal sTargetName As String, Optional ByVal sPassWord As String)
On Error GoTo Err
Screen.MousePointer = 13

    '����Ŀ���ļ���
    Dim sTarget As String
    Dim JRO As JRO.JetEngine
    Set JRO = New JRO.JetEngine
    'Ŀ�����ݿ��������
    sTarget = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & sTargetName & ";Jet OLEDB:Database Password=" & sPassWord
    '�ر�ԭ����,���ر�����ת��
    Cn.Close
    Set Cn = Nothing
    'ִ��ת�Q(ѹ��)
    JRO.CompactDatabase sConnectString, sTarget
    '��������
    Call cyCnOpen
    Screen.MousePointer = 0
    Exit Sub
Err:
'���ļ��Ѿ������
If Err.Number = -2147217897 Then
    On Error Resume Next
    Kill sTargetName
    'ִ��ת�Q(ѹ��)
    JRO.CompactDatabase sConnectString, sTarget
    '��������
    Call cyCnOpen
End If

Screen.MousePointer = 0
End Sub

'��������:cyRsToTreeView
'���ã������ݼ��󶨵�TreeView
'===========================================================
'����ʱ�䣺2006-12-31 12:59
'  ������
'           tvTreeView         --  ���󶨵����
'           Rs                 --  ��󶨵����ݼ�
'           OwnerIDField       --  ������¼��ID�ֶ�����
'           ParentIDField      --  ����¼��ID�ֶ�����
'           sNodeTextField     --  �ڵ��ַ���ʾ���ֶ�����
'           bNodeExpanded      --  �Ƿ�չ��


'  ���ӣ�            Set Rs = D.cyRsGetFromFile("c:\software.xml")
'                    D.cyRsToTreeView Me.TreeView1, Rs, "ID", "FATHERID", "TEXT", True

'===========================================================
Sub cyRsToTreeView(ByVal tvTreeView As Object, ByVal Rs As Recordset, ByVal OwnerIDField As String, ByVal ParentIDField As String, ByVal sNodeTextField As String, Optional ByVal bNodeExpanded As Boolean)
    Dim i As Long
    tvTreeView.Nodes.Clear
    Rs.MoveFirst
    For i = 1 To Rs.RecordCount
        If Rs(ParentIDField) = 0 Then
            tvTreeView.Nodes.Add , , "_" & Rs(OwnerIDField), Rs(sNodeTextField)
        
        Else
            tvTreeView.Nodes.Add "_" & Rs(ParentIDField), tvwChild, "_" & Rs(OwnerIDField), Rs(sNodeTextField)

        End If
        
        '�Ƿ�չ������
        tvTreeView.Nodes(i).Expanded = bNodeExpanded
        
        Rs.MoveNext
        
    Next

End Sub

Sub cyRsToCtl(ByVal Rs As Recordset, ByVal Ctl As Object, Optional ByVal sCellWidthLists As String)
Dim i As Long
Dim j As Long
Dim sType As String     '����������

'�õ�ÿ��Ŀ���

Dim iCellWidth() As String
On Error Resume Next
iCellWidth = Split(sCellWidthLists, ";")

'������ص����ݼ�û���α�����һ��RS
If Rs.RecordCount = -1 Then
    Set Rs = cyRsToRsEx(Rs)
End If

'��Rs�α��Ƶ���ǰ��
If Rs.RecordCount > 0 Then
    Rs.MoveFirst
End If

'�õ��ؼ�������
sType = TypeName(Ctl)
If sType = "ComboBox" Or sType = "ListBox" Then
        Dim iFieldCount As Long '��¼���ݼ����ֶ���,����ֶ�������1�������Ƿ�����,����������ӵ�ITEMDATA��
        iFieldCount = Rs.Fields.Count
        If iFieldCount = 1 Then '���ֻ��һ���ֶ���ֱ��д��ؼ�
            'ѭ��д������
            Do While Not Rs.EOF
                Ctl.AddItem CStr(Rs(0).Value)
                Rs.MoveNext
            Loop
        
        Else '�����һ�������ֶξͼ����ڶ����ֶ��Ƿ�����,�������д��ȥ
            'ѭ��д������
            Do While Not Rs.EOF
                Ctl.AddItem CStr(Rs.Fields(0))
                '��һ����ʾ�ڿؼ�,����ڶ�������������󶨵�ItemData
                If IsNumeric(Rs.Fields(1)) Then Ctl.itemData(i) = Rs.Fields(1)
                i = i + 1
                Rs.MoveNext
            Loop
        End If
        Exit Sub
ElseIf sType = "DataCombo" Or sType = "DataList" Then
        Ctl.ListField = Rs.Fields(0).name
        Set Ctl.RowSource = Rs
        Exit Sub
ElseIf sType = "DataGrid" Then
    
    Set Ctl.DataSource = Rs
On Error Resume Next
    For i = 0 To UBound(iCellWidth)
        Ctl.Columns(i).Width = iCellWidth(i)
    Next
ElseIf sType = "MSHFlexGrid" Then
    Set Ctl.DataSource = Rs
On Error Resume Next
    For i = 0 To UBound(iCellWidth)
        Ctl.ColWidth(i) = CLng(iCellWidth(i))
    Next
 
ElseIf sType = "MSFlexGrid" Then
    'ѭ��д������
    
    Do While Not Rs.EOF
        Ctl.cols = Rs.Fields.Count + 1
        For i = 0 To Rs.Fields.Count - 1
            Ctl.TextMatrix(Ctl.Rows - 1, i + 1) = Rs.Fields(i)
        Next
        Ctl.Rows = Ctl.Rows + 1
        Rs.MoveNext
    Loop
    Exit Sub
'        For j = 0 To Rs.RecordCount - 1
'        Rs.MoveNext
'        Next
'        Ctl.Rows = Ctl.Rows - 1
ElseIf sType = "ListView" Then
        
        Dim Fld As Field
        Dim FirstRow As Boolean
        Dim iWidth As Long
        Ctl.View = 3 'lvmReport
        Ctl.LabelEdit = 1 'lvwManual
        
        If Ctl.ColumnHeaders.Count = 0 Then
            For j = 0 To Rs.Fields.Count - 1
                If j > UBound(iCellWidth) Then
                    Ctl.ColumnHeaders.Add , , Rs.Fields(j).name            'CREATE COLUMN HEADERS
                
                Else
                    '�趨ÿ���Title,�������
                    Ctl.ColumnHeaders.Add , , Rs.Fields(j).name, iCellWidth(j)           'CREATE COLUMN HEADERS
                
                End If
            Next
            
        End If
        
On Error Resume Next
        For i = 0 To Rs.RecordCount - 1
            FirstRow = True
            For j = 0 To Rs.Fields.Count - 1
                If FirstRow Then                            'FIRST ROW IS A LIST ITEM
                    If Rs(j) <> "" Then
                        Ctl.ListItems.Add , , Rs(j)
                    Else
                        Ctl.ListItems.Add , , ""
                    End If
                    FirstRow = False
                Else
                    If Rs(j) <> "" Then
                        Ctl.ListItems.Item(Ctl.ListItems.Count).SubItems(j) = Rs(j)
                        Ctl.ListItems(Ctl.ListItems.Count).ListSubItems.Add , , Fld.Value   'REMAINING ROWS ARE SUBITEMS
                    Else
                        Ctl.ListItems.Item(Ctl.ListItems.Count).SubItems(j) = ""
                        Ctl.ListItems(Ctl.ListItems.Count).ListSubItems.Add , , ""      'INSERT BLANKS FOR NULLS SO DATA
                    End If                                      'DOESN'T COALESCE TO THE LEFT
                End If
            Next
            Rs.MoveNext
        Next
        Dim W As New cyWndEx
        W.cyWndAction Ctl.hWnd, LV_FullRowSel, 1
        W.cyWndAction Ctl.hWnd, LV_GirdLine, 1
End If
End Sub

Public Sub cySqlBackup(ByVal sDataBase As String, ByVal sBackUpFile As String)
Screen.MousePointer = 13

    Dim sBackup As String
    Screen.MousePointer = 11
    sBackup = "backup database " & sDataBase & " to disk='" + sBackUpFile + "'"
    Cn.Execute sBackup
    
Screen.MousePointer = 0
End Sub

Public Sub cySqlRestore(ByVal sDataBase As String, ByVal sBackUpFile As String)
Screen.MousePointer = 13

    Dim sRestore As String
    Dim Rs As New Recordset
        
    'ɾ��ԭ���ݿ��ڷ������ļ�¼
    Rs.Open "select  spid  from  sysprocesses  where  dbid=db_id('" & sDataBase & "')", Cn
    Do While Not Rs.EOF
        Cn.Execute "kill " & Rs("spid")
        Rs.MoveNext
    Loop
    Rs.Close
    Set Rs = Nothing
    
    'ʹ�ø���ģʽ�ָ����ݿ�
    sRestore = "restore database " & sDataBase & " from disk='" + sBackUpFile + "'  with REPLACE"
    Cn.Execute sRestore
    
Screen.MousePointer = 0
End Sub

'���Ӳ���
Sub cySP_Append(ByVal sParaName As String, ByVal varParaValue, Optional ByVal ParaType As DataTypeEnum, Optional ByVal ParaDirtion As ParameterDirectionEnum, Optional ByVal iSize As Integer)
    If ParaDirtion = 0 Then
        ParaDirtion = adParamInput
    End If
    
    If iSize = 0 And TypeName(varParaValue) = "String" Then
        Dim sStr As String
        sStr = varParaValue
        iSize = LenB(StrConv(varParaValue, vbFromUnicode))
    Else
        iSize = 20
    End If
    
    If ParaType = 0 Then
        Select Case TypeName(varParaValue)
            Case "Integer"
                ParaType = adInteger
            Case "Long"
                ParaType = adBigInt
            Case "String"
                ParaType = adChar
            Case "Date"
                ParaType = adDate
        End Select
    End If
    cmd.Parameters.Append cmd.CreateParameter(sParaName, ParaType, ParaDirtion, iSize, varParaValue)
End Sub

'ִ�д洢����
Function cySP_Execute(ByVal SP_Name As String) As Recordset
    
    Set cmd.ActiveConnection = Cn 'ָʾָ���� Command����ǰ������ Connection����
    cmd.CommandText = "sp_Fold_Update" '����Command����Դ��
    cmd.CommandType = adCmdStoredProc '֪ͨ�ṩ��CommandText������ʲô�������ܰ���Command�����Դ���͡�������������Ż��˸������ִ�С�
    cmd.Parameters.Append cmd.CreateParameter("@ID", adInteger, adParamInput, 255, 43788)
    cmd.Parameters.Append cmd.CreateParameter("@OldPage", adInteger, adParamInput, 255, 16)
    cmd.Parameters.Append cmd.CreateParameter("@NewPage", adInteger, adParamInput, 255, 8)
    cmd.Parameters.Append cmd.CreateParameter("@oldPageList", adVarChar, adParamInput, 255, "1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16")
    cmd.Parameters.Append cmd.CreateParameter("@NewPageList", adVarChar, adParamInput, 255, "1;2;3;4;5;6;7;8")
    
    Dim Rs As Recordset
    Set Rs = cmd.Execute



    cmd.ActiveConnection = Cn
    Cn.CursorLocation = adUseClient
    cmd.CommandText = SP_Name
    cmd.CommandType = adCmdStoredProc
    
    Rs.CursorType = 3
    Rs.Open cmd, , 1, 3
    
    '�������
    Dim i As Long
    For i = 1 To cmd.Parameters.Count
        cmd.Parameters.Delete 0
    Next
End Function

'��ʼ����
Sub cyCnBegintrans()
    Cn.BeginTrans
End Sub

'����ع�
Sub cyCnRollbackTrans()
    Cn.RollbackTrans
End Sub

'�������
Sub cyCnCommitTrans()
    Cn.CommitTrans
End Sub


'��������:cyMdbRsExport

'���ã�����ǰ��RecordSet������������ʽ

'##################################################
'����ʱ�䣺2004-2-11 15:35:36
'  ������
'   sSQL As String    --ִ�е�SQL���
'   iType As ExportType     --����(FoxBase/Html/Text/Excel)
'   sFileName As String  --Ŀ���ļ���(txt/xls..)
'##################################################
'  ����
Function cyMdbRsExport(sSQL As String, iType As ExportType, ByVal sFileName As String, Optional ByVal sXlsSheetName As String)

    On Error Resume Next
    Kill sFileName
    On Error GoTo 0
    
'�����ļ�·�����ļ�������ɵ������
    Dim i As Integer
    Dim sPath As String
    Dim sFile As String
    Dim sTemp As String '���into�����
    For i = Len(sFileName) To 1 Step -1
        If Mid(sFileName, i, 1) = "\" Then Exit For
    Next
    sPath = Left(sFileName, i - 1)
    sFile = Mid$(sFileName, i + 1, Len(sFileName) - i)

'���������
    Dim sTableName As String
    sSQL = UCase(Replace(sSQL, "  ", " "))
    i = InStr(1, sSQL, " FROM ")
    i = InStr(i + 5, sSQL, " ")
    If InStr(i + 1, sSQL, " ") = 0 Then
        '������û����������ʽ
        sTableName = Right(sSQL, Len(sSQL) - i)
    Else
        '�������� Where ����������ʽ
        sTableName = Mid(sSQL, i + 1, InStr(i + 1, sSQL, " ") - i - 1)
    End If

    '����ж��Ʊ��������
    If (sXlsSheetName <> "" And iType = Export2Excel) Then sTableName = sXlsSheetName


Select Case iType
    Case 1
        'Visual FoxPro 3.0          FoxPro 3.0; drive:\path
        sTemp = " INTO [FoxPro 3.0;DATABASE=" + sPath + "].[" + sFile + "] "
    Case 2
        'Microsoft  97         Excel 8.0; drive:\path\filename.xls
        sTemp = " INTO [Excel 8.0;DATABASE=" + sPath + "\" + sFile + "].[" + sTableName + "]"
    Case 4
        'HTML                       Import HTML Import; drive:\path\filename
        'HTML                       Export HTML Export; drive:\path
        sTemp = " INTO [HTML Export;DATABASE=" + IIf(Right(sPath, 1) = "\", sPath, sPath & "\") + "].[" + sFile + "] "
    Case 5
        'Text                       Text; drive:\path
        sTemp = " INTO [text;DATABASE=" + IIf(Right(sPath, 1) = "\", sPath, sPath & "\") + "].[" + sFile + "] "
        'sTemp = " INTO [ODBC;DATABASE=pubs;UID=sa;PWD=;DSN=myODBC;] "
    Case 20
        'ODBC                       [LOGINTIMEOUT=seconds;]        NonePath
    Case 21
        'Microsoft Exchange         Exchange 4.0;MAPILEVEL=folderpath; [TABLETYPE={ 0 | 1 }];[PROFILE=profile;][PWD=password;][DATABASE=database;]

End Select


    i = InStr(1, sSQL, " FROM ")
    sPath = Left(sSQL, i)
    sFile = Right(sSQL, Len(sSQL) - i)
    sSQL = sPath + sTemp + sFile
    '��������������


    Dim cmd As New ADODB.Command
    cmd.ActiveConnection = Cn
    cmd.CommandType = adCmdText
    cmd.CommandText = sSQL
    cmd.Execute
    cyMdbRsExport = True
End Function

'����һ�����ݼ��Ľṹ
Function cyRsToRs(ByVal Rs As Recordset) As Recordset
    Set cyRsToRs = Rs.Clone(adLockOptimistic)
    Set cyRsToRs.ActiveConnection = Nothing
End Function

'����һ��û��RECORDCOUNT�����ݼ��ṹ
Function cyRsToRsEx(ByVal Rs As Recordset) As Recordset
    Dim tmpRs As New Recordset
    Dim iFieldCount As Long
    iFieldCount = Rs.Fields.Count
    Dim i As Long
    
    '�½�һ�����ݼ�
    tmpRs.CursorLocation = adUseClient
    For i = 0 To iFieldCount - 1
        tmpRs.Fields.Append Rs(i).name, Rs(i).type, Rs(i).DefinedSize, Rs(i).Attributes
    Next
    tmpRs.Open
    
    'ѭ��д������
    Do While Not Rs.EOF
        tmpRs.AddNew
        For i = 0 To iFieldCount - 1
            tmpRs(i) = Rs(i)
        Next
        Rs.MoveNext
    Loop
    tmpRs.MoveFirst
    Set cyRsToRsEx = tmpRs
End Function

'�������ݼ���ĳ�ֶε��ܺ�
Function cyRsFieldSum(ByVal Rs As Recordset, sField As String)
Screen.MousePointer = 13

    Dim tmpRs As Recordset
    Dim iCount
    Dim i As Long
    Set tmpRs = Rs.Clone(adLockReadOnly)
    If tmpRs.RecordCount = 0 Then Exit Function
    tmpRs.MoveFirst
    For i = 0 To tmpRs.RecordCount - 1
        If Not IsNull(tmpRs(sField).Value) Then iCount = tmpRs(sField).Value + iCount
        tmpRs.MoveNext
    Next
    cyRsFieldSum = iCount

End Function

'��������:cyGetRsOneField
'���ã�����SQL��䷵��ĳ����¼��ĳ���ֶε�ֵ(���û��ֵ���ȱʡֵ)
'  ����
Function cyGetRsOneField(ByVal sSQL As String, Optional ByVal DefaultValue As Variant)
    Dim tmpRs As Recordset
    Set tmpRs = New ADODB.Recordset
    tmpRs.CursorLocation = adUseClient
    tmpRs.CursorType = adOpenKeyset
    tmpRs.LockType = adLockOptimistic
    tmpRs.Open sSQL, Cn, , , adCmdText
    If tmpRs.RecordCount > 0 Then
    '�����ݼ�¼����
        If IsNull(tmpRs(0).Value) Then
        '���ֵΪNULL,�򷵻�ȱʡֵ
            cyGetRsOneField = DefaultValue
        Else
        '��ΪNULL���򷵻ظ�ֵ
            cyGetRsOneField = tmpRs(0).Value
        End If
    Else
        'û�������ȱʡֵ
        cyGetRsOneField = DefaultValue
        
    End If
End Function

'��������:cyExcelToRs
'���ã���Excel�ļ����뵽���ݼ�
'===========================================================
'����ʱ�䣺2008-12-20 16:29
'  ������
'           sFileName       --  Excel�ļ���
'           sSheetName      --  Excel�ļ��ı���(�粻�ṩ,��ʹ�õ�Sheet1)

'  ���ӣ�   Set Rs = D.cyExcelToRs("c:\1.xls", "Sheet1")

'===========================================================
Public Function cyExcelToRs(ByVal sFileName As String, Optional ByVal sSheetName As String) As Recordset
    
On Error GoTo Err
    Const adOpenStatic = 3
    Dim Rs As Recordset
    Dim Conn As Connection
    
    '���δ�ṩ������ʹ��ȱʡ����
    If sSheetName = "" Then sSheetName = "Sheet1"
    
    '��Excel�������ݼ�
    Set Conn = CreateObject("ADODB.Connection")
    
    Conn.Open "driver={Microsoft Excel Driver (*.xls)};dbq=" & sFileName
    Set Rs = CreateObject("ADODB.Recordset")
    
    '��Excel��ĳ����
    Rs.Open "[" & sSheetName & "$]", Conn, adOpenStatic
    
    '�������ݼ�
    Set cyExcelToRs = Rs
    
    '�������
    Set Rs = Nothing
    Set Conn = Nothing
    Exit Function
Err:
    
    If Err.Number = -2147217900 Then
    '��������ȷ
        Err.Raise -999, "", "���ṩ��ȷ��Sheet����!"
        
    Else
    '��������
        Err.Raise Err.Number, Err.Source, Err.Description
        
    End If
    
End Function

'sWidthsList��ʽ����:Ϊ1���ӡ,Ϊ0��Ϊ���򲻴�ӡ.
' 1;;1; ֻ��ӡ��1/3��
Public Function cyRsToExcel(ByVal Rs As Recordset, ByVal sFileName As String, Optional ByVal sSheetName As String, Optional ByVal sWidthsList As String) As Boolean
Dim tmpRs As Recordset
Dim sA() As String  '�����Ƿ��ӡ�б�
Dim exl
Dim xlsWorkBook
Dim xlsWorkSheet
Set tmpRs = Rs.Clone(adLockReadOnly)
Set exl = CreateObject("Excel.Application")

Dim S As New cySystemEx
Dim W As New cyWndEx


Set xlsWorkBook = exl.Workbooks.Add
Set xlsWorkSheet = xlsWorkBook.Worksheets.Add

Dim i As Long
Dim j As Long

    If sWidthsList <> "" Then
    '��Ϊ�����ʾ��������
        sA = Split(sWidthsList, ";")
        '�����б�������tmprs���ֶ��������,���ض���ʹ�����
        If UBound(sA) <> tmpRs.Fields.Count Then
            ReDim Preserve sA(tmpRs.Fields.Count - 1)
            
        End If
    
        '��д���ֶ���
        For j = 0 To tmpRs.Fields.Count - 1
            '����Ҫ�����ֱ�Ӵ�ӡ
            xlsWorkSheet.Cells(i + 1, j + 1) = tmpRs.Fields(j).name
            xlsWorkSheet.Columns(Chr(65 + j)).ColumnWidth = IIf(IsNumeric(sA(j)), sA(j), 0)
    
        Next
    
    Else
    'Ϊ������ԭ�����п�
    
        '��д���ֶ���
        For j = 0 To tmpRs.Fields.Count - 1
            '����Ҫ�����ֱ�Ӵ�ӡ
            xlsWorkSheet.Cells(i + 1, j + 1) = tmpRs.Fields(j).name
    
        Next
    
    End If
    
    tmpRs.MoveFirst
    
    If tmpRs.RecordCount > 1000 Then    '����һǧ������ʾ������
        W.cyRunningBar ShowBar
        W.cyRunningBar ShowMsg, "���ڵ���..."
        For i = 0 To tmpRs.RecordCount - 1
            If i Mod 1000 = 0 Then
                W.cyRunningBar ShowPercent, (i / tmpRs.RecordCount) * 100
            End If
        
        
            'д���ֶ�����
            For j = 0 To tmpRs.Fields.Count - 1
                '����Ҫ�����ֱ�Ӵ�ӡ
                xlsWorkSheet.Cells(i + 2, j + 1) = tmpRs(j).Value
                
            Next
            tmpRs.MoveNext
            
        Next
        W.cyRunningBar CloseBar
    Else
        For i = 0 To tmpRs.RecordCount - 1
            'д���ֶ�����
            For j = 0 To tmpRs.Fields.Count - 1
                '����Ҫ�����ֱ�Ӵ�ӡ
                xlsWorkSheet.Cells(i + 2, j + 1) = tmpRs(j).Value
                
            Next
            tmpRs.MoveNext
            
        Next
    
    End If
    xlsWorkSheet.Range("A1", "Z1").Font.Bold = True
    xlsWorkSheet.Cells.Font.Size = 10
    'Excel.Worksheets.PrintOut
    
    If sSheetName = "" Then
    '�������Ϊ����ʹ��ȱʡ�ı���
        xlsWorkBook.ActiveSheet.name = "���ݵ���"
    Else
    '���ṩ������ʹ���ṩ�ı���
        xlsWorkBook.ActiveSheet.name = sSheetName
    End If
    
    On Error Resume Next

    xlsWorkBook.SaveAs sFileName
    xlsWorkBook.Close
    
    Set xlsWorkBook = Nothing
    Set xlsWorkSheet = Nothing
    
    cyRsToExcel = True

    W.cyRunningBar CloseBar

End Function

'��������:cyRsAppend
'���ã��������ṹ��ȫһ�������ݼ��ϲ�
'===========================================================
'����ʱ�䣺2006-12-31 12:59
'  ������
'           RsDistination --  �ϲ�������ݼ�(Rs1)
'           RsSource      --  ��ϲ������ݼ�(Rs2)

'  ���ӣ�        Call D.cyRsAppend(Rs1, Rs2)
'===========================================================
Sub cyRsAppend(ByRef RsDistination As Recordset, ByVal RsSource As Recordset)
    Dim i As Long
    Dim j As Long
    'ѭ����ȡ�����ӵ�Rs
    
    RsSource.MoveFirst
    
    For i = 1 To RsSource.RecordCount
        '��������
        RsDistination.AddNew
            '����ֶ�׷��
            For j = 0 To RsDistination.Fields.Count - 1
                RsDistination(j).Value = RsSource(j).Value
            Next
        RsSource.MoveNext
    Next
    '��������
    RsDistination.UpdateBatch
    
End Sub

'��������:cyDelDoubleDatas
'���ã�ɾ������ĳ�����ֶ�������ͬ��������,ֻ������һ��
'===========================================================
'����ʱ�䣺2006-12-31 12:59
'  ������
'           sTable              --����
'           sFieldID            --Ψһ��ʶ��ID�ֶ���������
'           sFieldLists         --�ֶ��б�,ʹ��,�ָ�

'  ���ӣ�            D.cyDelDoubleDatas "(local)", "pubs", "sa", "123456", "discounts", "ID", "stor_id,lowqty,highqty,discount"

'===========================================================
Sub cyDelDoubleDatas(ByVal sServer As String, ByVal sDataBase As String, ByVal sID As String, ByVal sPassWord As String, ByVal sTable As String, ByVal sFieldID As String, ByVal sFieldLists As String)
    Dim i As Long
    Dim D As New cyDataBaseEx
    Dim Rs As Recordset
    Dim sA() As String
    Dim sStr As String
    Dim sSQL As String
    sFieldLists = Replace(sFieldLists, ";", ",")
    sA = Split(sFieldLists, ",")
    For i = 0 To UBound(sA)
        sStr = sStr & "t1." & sA(i) & " = a." & sA(i) & " AND "
        
    Next
    sStr = Left(sStr, Len(sStr) - 4)
    
    Select Case MsgBox("�Ƿ�ȷ��ɾ��(�ֶ�:" & sFieldLists & ")�ظ�������?" & "����ȷ���ѱ�������.", vbYesNo Or vbQuestion Or vbSystemModal Or vbDefaultButton2, "")
    
        Case vbYes
    
        Case vbNo
            Exit Sub
            
    End Select
    
    sSQL = "SELECT * " + _
       "FROM " & sTable & " " + _
       "WHERE (" & sFieldID & " NOT IN (SELECT " & sFieldID & " " + _
       "FROM " & sTable & " a LEFT OUTER JOIN (SELECT " & sFieldLists & " " + _
       "FROM " & sTable & " " + _
       "GROUP BY " & sFieldLists & " HAVING COUNT(*) > 1) t1 ON " & sStr + _
       "WHERE a." & sFieldID & " NOT IN (SELECT MAX(" & sFieldID & ") " + _
       "FROM " & sTable & " " + _
       "GROUP BY " & sFieldLists & " HAVING COUNT(*) > 1))) "

    D.cyConnectSqlServer sServer, sDataBase, sID, sPassWord

    Set Rs = D.cyGetRs(sSQL)
    
    Do While Rs.RecordCount > 0
        D.cyExeCute "DELETE " & Right(sSQL, Len(sSQL) - 8)
    
        sSQL = "SELECT * " + _
           "FROM " & sTable & " " + _
           "WHERE (" & sFieldID & " NOT IN (SELECT " & sFieldID & " " + _
           "FROM " & sTable & " a LEFT OUTER JOIN (SELECT " & sFieldLists & " " + _
           "FROM " & sTable & " " + _
           "GROUP BY " & sFieldLists & " HAVING COUNT(*) > 1) t1 ON " & sStr + _
           "WHERE a." & sFieldID & " NOT IN (SELECT MAX(" & sFieldID & ") " + _
           "FROM " & sTable & " " + _
           "GROUP BY " & sFieldLists & " HAVING COUNT(*) > 1))) "
    
        Set Rs = D.cyGetRs(sSQL)
    
    Loop

End Sub
