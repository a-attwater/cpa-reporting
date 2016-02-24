Imports Microsoft.VisualBasic
Imports System.IO
Imports System
Imports System.Data.SqlClient
Imports System.Data
Imports System.Data.OleDb
Imports System.Net.Mail
Imports System.Web.HttpContext
Imports System.Collections
Imports System.Text
Imports System.Web
Imports System.Configuration

Public Class admin
    Public Shared sqlCon As SqlConnection = New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("SqlConnection"))
    Public Shared sqlCom As SqlCommand
    Public Shared sqlDR As SqlDataReader
    Public Shared sqlDS As DataSet
    Public Shared sqlDA As SqlDataAdapter

    Public Shared Function pagesAdd(ByVal strPageName As String, ByVal strPageURL As String, ByVal intParentID As Integer) As Integer
        sqlCom = New SqlCommand("pagesAdd", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure

        sqlCom.Parameters.Add("@strPageName", SqlDbType.NVarChar, 150).Value = strPageName
        sqlCom.Parameters.Add("@strPageURL", SqlDbType.NVarChar, 150).Value = strPageURL
        sqlCom.Parameters.Add("@intParentID", SqlDbType.Int).Value = intParentID

        Dim pageID As SqlParameter = sqlCom.Parameters.Add("@returnvalue", SqlDbType.Int)
        pageID.Direction = ParameterDirection.ReturnValue

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlCom.ExecuteNonQuery()

        sqlCon.Close()
        sqlCom.Dispose()

        Return pageID.Value
    End Function

    Public Shared Sub pagesUpdate(ByVal intID As Integer, ByVal strPageName As String, ByVal strPageURL As String)
        sqlCom = New SqlCommand("pagesUpdate", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure

        sqlCom.Parameters.Add("@fldID", SqlDbType.Int).Value = intID
        sqlCom.Parameters.Add("@fldName", SqlDbType.NVarChar, 150).Value = strPageName
        sqlCom.Parameters.Add("@fldURL", SqlDbType.NVarChar, 150).Value = strPageURL

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlCom.ExecuteNonQuery()

        sqlCon.Close()
        sqlCom.Dispose()
    End Sub

    Public Shared Function pagesDelete(ByVal intID As Integer) As Integer
        sqlCom = New SqlCommand("pagesDelete", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure

        sqlCom.Parameters.Add("@fldID", SqlDbType.Int).Value = intID

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        Try
            sqlCom.ExecuteScalar()
            Return 1
        Catch ex As Exception
            Return 0
        End Try

        sqlCon.Close()

    End Function

    Public Shared Sub initPagesDDL(ByVal ddlPages As DropDownList)
        sqlCom = New SqlCommand("SELECT fldID, fldName FROM tAdminPages WHERE fldParentID = 0 ORDER BY fldName", sqlCon)

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If
        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "Pages")
        sqlCon.Close()
        sqlCom.Dispose()
        sqlDA.Dispose()

        ddlPages.Items.Clear()
        ddlPages.DataSource = sqlDS.Tables("Pages")
        ddlPages.DataTextField = "fldName"
        ddlPages.DataValueField = "fldID"
        ddlPages.DataBind()
        sqlDS.Dispose()

        ddlPages.Items.Insert(0, New ListItem("<==Please Select==>", "0"))
    End Sub

    Public Shared Function pagesSelList() As DataSet
        sqlCom = New SqlCommand("SELECT * FROM tAdminPages WHERE fldParentID = 0", sqlCon)

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "pages")
        sqlCom.Dispose()
        sqlDS.Dispose()

        Return sqlDS
        sqlDS.Dispose()
    End Function

    Public Shared Function pagesSelSubPages(ByVal pageID As Integer) As DataSet
        sqlCom = New SqlCommand("SELECT * FROM tAdminPages WHERE fldParentID = " & pageID, sqlCon)

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "pages")
        sqlCom.Dispose()
        sqlDS.Dispose()

        Return sqlDS
        sqlDS.Dispose()
    End Function

    Public Shared Function pagesGetName(ByVal pageID As Integer) As String
        sqlCom = New SqlCommand("SELECT fldName FROM tAdminPages WHERE fldID = " & pageID, sqlCon)

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        Dim pageName As String = sqlCom.ExecuteScalar()

        sqlCon.Close()
        Return pageName
    End Function

    Public Shared Function usersSel(ByVal userID As Integer) As DataSet
        sqlCom = New SqlCommand("SELECT * FROM tAdminUsers WHERE fldID = " & userID, sqlCon)

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "user")
        sqlCom.Dispose()
        sqlDS.Dispose()

        Return sqlDS
        sqlDS.Dispose()
    End Function

    Public Shared Function usersAdd(ByVal strUsername As String, ByVal strPassword As String, ByVal strName As String, ByVal strEmail As String, ByVal isAdmin As Boolean, ByVal isActive As Boolean) As Integer
        sqlCom = New SqlCommand("usersAdd", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure

        sqlCom.Parameters.Add("@strUsername", SqlDbType.NVarChar, 50).Value = strUsername
        sqlCom.Parameters.Add("@strPassword", SqlDbType.NVarChar, 50).Value = strPassword
        sqlCom.Parameters.Add("@strName", SqlDbType.NVarChar, 50).Value = strName
        sqlCom.Parameters.Add("@strEmail", SqlDbType.NVarChar, 50).Value = strEmail
        sqlCom.Parameters.Add("@isAdmin", SqlDbType.Bit).Value = isAdmin
        sqlCom.Parameters.Add("@isActive", SqlDbType.Bit).Value = isActive

        Dim userID As SqlParameter = sqlCom.Parameters.Add("@returnvalue", SqlDbType.Int)
        userID.Direction = ParameterDirection.ReturnValue

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlCom.ExecuteNonQuery()

        sqlCon.Close()
        sqlCom.Dispose()

        Return userID.Value

    End Function

    Public Shared Sub usersUpdate(ByVal intID As Integer, ByVal strUsername As String, ByVal strPassword As String, ByVal strName As String, ByVal strEmail As String, ByVal isAdmin As Boolean, ByVal isActive As Boolean)
        sqlCom = New SqlCommand("usersUpdate", sqlCon)
        sqlCom.CommandType = CommandType.StoredProcedure

        sqlCom.Parameters.Add("@intID", SqlDbType.Int).Value = intID
        sqlCom.Parameters.Add("@strUsername", SqlDbType.NVarChar, 50).Value = strUsername
        sqlCom.Parameters.Add("@strPassword", SqlDbType.NVarChar, 50).Value = strPassword
        sqlCom.Parameters.Add("@strName", SqlDbType.NVarChar, 50).Value = strName
        sqlCom.Parameters.Add("@strEmail", SqlDbType.NVarChar, 50).Value = strEmail
        sqlCom.Parameters.Add("@isAdmin", SqlDbType.Bit).Value = isAdmin
        sqlCom.Parameters.Add("@isActive", SqlDbType.Bit).Value = isActive


        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlCom.ExecuteNonQuery()

        sqlCon.Close()
        sqlCom.Dispose()

    End Sub

    Public Shared Sub usersPagesDelete(ByVal userID As Integer)
        sqlCom = New SqlCommand("DELETE FROM tAdminUsersPages WHERE fldUserID = " & userID, sqlCon)

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlCom.ExecuteNonQuery()

        sqlCon.Close()
        sqlCom.Dispose()
    End Sub

    Public Shared Sub usersPagesInsert(ByVal userID As Integer, ByVal pageID As Integer)
        sqlCom = New SqlCommand("INSERT INTO tAdminUsersPages(fldUserID, fldPageID) VALUES(" & userID & ", " & pageID & ")", sqlCon)

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlCom.ExecuteNonQuery()

        sqlCon.Close()
        sqlCom.Dispose()
    End Sub

    Public Shared Function usersPagesSel(ByVal userID As Integer) As DataSet
        sqlCom = New SqlCommand("SELECT * FROM tAdminUsersPages WHERE fldUserID = " & userID, sqlCon)

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "userPages")
        sqlCom.Dispose()
        sqlDS.Dispose()

        Return sqlDS
        sqlDS.Dispose()
    End Function

    Public Shared Function usersPagesSelNav(ByVal userID As Integer) As DataSet
        sqlCom = New SqlCommand("usersPagesSelNav", sqlCon)
        sqlCom.Parameters.Add("@userID", SqlDbType.Int).Value = userID

        sqlCom.CommandType = CommandType.StoredProcedure

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "userPages")
        sqlCom.Dispose()
        sqlDS.Dispose()

        Return sqlDS
        sqlDS.Dispose()
    End Function

    Public Shared Function userLogin(ByVal strUsername As String, ByVal strPassword As String) As DataSet
        sqlCom = New SqlCommand("SELECT * FROM tAdminUsers WHERE fldUserName = '" & strUsername & "' and fldPWD = '" & strPassword & "'", sqlCon)

        If sqlCon.State = ConnectionState.Closed Then
            sqlCon.Open()
        End If

        sqlDA = New SqlDataAdapter
        sqlDA.SelectCommand = sqlCom
        sqlDS = New DataSet
        sqlDA.Fill(sqlDS, "userDetails")
        sqlCom.Dispose()
        sqlDS.Dispose()

        Return sqlDS
        sqlDS.Dispose()
    End Function
End Class
