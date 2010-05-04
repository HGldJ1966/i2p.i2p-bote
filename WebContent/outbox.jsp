<%--
 Copyright (C) 2009  HungryHobo@mail.i2p
 
 The GPG fingerprint for HungryHobo@mail.i2p is:
 6DD3 EAA2 9990 29BC 4AD2 7486 1E2C 7B61 76DC DC12
 
 This file is part of I2P-Bote.
 I2P-Bote is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 I2P-Bote is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with I2P-Bote.  If not, see <http://www.gnu.org/licenses/>.
 --%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ib" uri="I2pBoteTags" %>

<%
    pageContext.setAttribute("FROM", i2p.bote.email.EmailAttribute.FROM, PageContext.PAGE_SCOPE);
    pageContext.setAttribute("TO", i2p.bote.email.EmailAttribute.TO, PageContext.PAGE_SCOPE);
    pageContext.setAttribute("SUBJECT", i2p.bote.email.EmailAttribute.SUBJECT, PageContext.PAGE_SCOPE);
    pageContext.setAttribute("STATUS", i2p.bote.email.EmailAttribute.STATUS, PageContext.PAGE_SCOPE);
%> 

<c:set var="title" value="Outbox" scope="request"/>
<jsp:include page="header.jsp"/>

<c:set var="sortcolumn" value="${STATUS}"/>
<c:if test="${!empty param.sortcolumn}">
    <c:set var="sortcolumn" value="${param.sortcolumn}"/>
</c:if>

<c:choose>
    <c:when test="${empty param.descending}">
        <c:set var="descending" value="false"/>
    </c:when>
    <c:otherwise>
        <%-- Set the sort direction depending on param.descending --%>
        <c:set var="descending" value="false"/>
        <c:if test="${param.descending}">
            <c:set var="descending" value="true"/>
        </c:if>
    </c:otherwise>
</c:choose>

<c:if test="${!descending}">
    <c:set var="sortIndicator" value="&#x25b4;"/>
    <c:set var="reverseSortOrder" value="&descending=true"/>
</c:if>
<c:if test="${descending}">
    <c:set var="sortIndicator" value="&#x25be;"/>
    <c:set var="reverseSortOrder" value="&descending=false"/>
</c:if>

<div class="main">
<div class="folder">
    <table>
        <c:set var="folder" value="${ib:getMailFolder('Outbox')}"/>
        <tr>
            <th style="width: 100px;">
                <c:set var="sortLink" value="outbox.jsp?sortcolumn=${FROM}"/>
                <c:if test="${sortcolumn eq FROM}">
                    <c:set var="sortLink" value="${sortLink}${reverseSortOrder}"/>
                    <c:set var="fromColumnIndicator" value=" ${sortIndicator}"/>
                </c:if>
                <a href="${sortLink}"><ib:message key="From"/>${fromColumnIndicator}</a>
            </th>
            <th style="width: 100px;">
                <c:set var="sortLink" value="outbox.jsp?path=${param.path}&sortcolumn=${TO}"/>
                <c:if test="${sortcolumn eq TO}">
                    <c:set var="sortLink" value="${sortLink}${reverseSortOrder}"/>
                    <c:set var="toColumnIndicator" value=" ${sortIndicator}"/>
                </c:if>
                <a href="${sortLink}"><ib:message key="To"/>${toColumnIndicator}</a>
            </th>
            <th style="width: 150px;">
                <c:set var="sortLink" value="outbox.jsp?sortcolumn=${SUBJECT}"/>
                <c:if test="${sortcolumn eq SUBJECT}">
                    <c:set var="sortLink" value="${sortLink}${reverseSortOrder}"/>
                    <c:set var="subjectColumnIndicator" value=" ${sortIndicator}"/>
                </c:if>
                <a href="${sortLink}"><ib:message key="Subject"/>${subjectColumnIndicator}</a>
            </th>
            <th style="width: 100px;">
                <c:set var="sortLink" value="outbox.jsp?sortcolumn=${STATUS}"/>
                <c:if test="${sortcolumn eq STATUS}">
                    <c:set var="sortLink" value="${sortLink}${reverseSortOrder}"/>
                    <c:set var="statusColumnIndicator" value=" ${sortIndicator}"/>
                </c:if>
                <a href="${sortLink}"><ib:message key="Status"/>${statusColumnIndicator}</a>
            </th>
            <th style="width: 20px;"></th>
        </tr>
        
        <c:forEach items="${ib:getEmails(folder, sortcolumn, descending)}" var="email" varStatus="status">
            <c:if test="${status.index%2 == 0}">
                <tr>
            </c:if>
            <c:if test="${status.index%2 != 0}">
                <tr class="altrow">
            </c:if>
            <c:set var="sender" value="${ib:getNameAndDestination(email.sender)}"/>
            <c:if test="${empty sender}">
                <ib:message key="Anonymous" var="sender"/>
            </c:if>
            
            <c:set var="recipient" value="${ib:getNameAndDestination(email.oneRecipient)}"/>
            
            <c:set var="subject" value="${email.subject}"/>
            <c:if test="${empty subject}">
                <ib:message key="(No subject)" var="subject"/>
            </c:if>
            
            <c:set var="mailUrl" value="showEmail.jsp?folder=Outbox&messageID=${email.messageID}"/>
            
            <c:choose>
                <c:when test="${email.new}"><c:set var="fontWeight" value="bold"/></c:when>
                <c:otherwise><c:set var="fontWeight" value="normal"/></c:otherwise>
            </c:choose>
            
            <c:if test="${status.index%2 == 0}">
                <c:set var="class" value="ellipsis"/>
            </c:if>
            <c:if test="${status.index%2 != 0}">
                <c:set var="class" value="ellipsis-alt"/>
            </c:if>
            <td><div class="${class}"><a href="${mailUrl}" style="font-weight: ${fontWeight}">${fn:escapeXml(sender)}</a></div></td>
            <td><div class="${class}"><a href="${mailUrl}" style="font-weight: ${fontWeight}">${fn:escapeXml(recipient)}</a></div></td>
            <td><div class="${class}"><a href="${mailUrl}" style="font-weight: ${fontWeight}">${fn:escapeXml(subject)}</a></div></td>
            <td><a href="${mailUrl}" style="font-weight: ${fontWeight}">${ib:getEmailStatus(email)}</a></td>
            <td>
                <a href="deleteEmail.jsp?folder=Outbox&messageID=${email.messageID}">
                <img src="images/delete.png" alt="<ib:message key='Delete'/>" title="<ib:message key='Delete this email'/>"/></a>
            </td>
            </tr>
        </c:forEach>
    </table>
</div>
</div>

<jsp:include page="footer.jsp"/>