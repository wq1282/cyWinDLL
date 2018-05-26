VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cyTimers"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'---------------------------------------------------------------------------------------
' ģ����:   modTimers
' ��������: 2006-10-12 22:45
' ����:     ����
' QQ:       38284035 �����BUG���и��õĽ��鲻��Q�ҹ�ͬ̽��

' ģ������: �и���VB�Դ���Timer�ؼ����ܻ�����Խ������粻�ܴ�������60���ʱ���¼���ʱ��
'           ��׼ȷ�����TIMER������ִ����ĳЩ���룬���Ӱ�쵽�´�ִ�е�׼ȷ�ԣ�����˷�
'           װ��һ�����У��Է�����á�

'           �书���У�
'           1.������ʱ�伤��
'             �趨δ����ĳһ��ʱ�䣬�磺2006-10-12 33:45:05���򵽴��ʱ��ʱ���
'           2.�����ʱ�伤��
'             �趨ĳ������������ÿ�롢ÿСʱ��ÿ��
'           3.�����趨ֻ����һ��
'             ���ú������д����ֹͣ��TIMER����ֻ����һ��

'---------------------------------------------------------------------------------------
Option Explicit

Public Event TimerEvent()
Private m_TimerID As Long

Friend Property Let ID(ByVal plngValue As Long)
    m_TimerID = plngValue
End Property

Friend Property Get ID() As Long
    ID = m_TimerID
End Property

Private Sub Class_Terminate()
    cyTimerStop
End Sub

'�����¼�
Friend Sub RaiseTimerEvent(ByVal bRunOnce As Boolean)
    If bRunOnce Then
        'ֻҪ������һ�Σ�
        cyTimerStop
    End If
    
    RaiseEvent TimerEvent
End Sub

'��������:cyTimerSetAlert
'���ã���������
'===========================================================
'����ʱ�䣺2006-9-18 22:55
'  ������
'===========================================================
Public Sub cyTimerSetAlert(ByVal AlertDateTime As Date)
    cyTimerStart DateDiff("s", Now, AlertDateTime), True
    
End Sub

'��������:cyTimerStart
'���ã���ʼ��ʱ��
'===========================================================
'����ʱ�䣺2006-9-18 22:55
'  ������
'===========================================================
Public Sub cyTimerStart(ByVal sinSecond As Single, Optional ByVal bRunOnce As Boolean = False)
        AddTimer Me, sinSecond * (10 ^ 3), bRunOnce

End Sub

'��������:cyTimerStop
'���ã�ֹͣ��ʱ��
'===========================================================
'����ʱ�䣺2006-9-18 22:55
'  ������
'===========================================================
Public Sub cyTimerStop()
    If m_TimerID > 0 Then
        RemoveTimer Me
    End If
End Sub

Public Sub cyDayClock(Optional ByVal bRunOnce As Boolean)
    cyTimerStart 60 ^ 2 * 24, bRunOnce

End Sub

Public Sub cyHourClock(Optional ByVal bRunOnce As Boolean)
    cyTimerStart 3600, bRunOnce

End Sub

Public Sub cyMinuteClock(Optional ByVal bRunOnce As Boolean)
    cyTimerStart 60, bRunOnce

End Sub

Public Sub cySecondClock(Optional ByVal bRunOnce As Boolean)
    cyTimerStart 1, bRunOnce

End Sub
