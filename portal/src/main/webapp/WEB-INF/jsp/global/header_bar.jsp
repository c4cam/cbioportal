<%--
 - Copyright (c) 2015 Memorial Sloan-Kettering Cancer Center.
 -
 - This library is distributed in the hope that it will be useful, but WITHOUT
 - ANY WARRANTY, WITHOUT EVEN THE IMPLIED WARRANTY OF MERCHANTABILITY OR FITNESS
 - FOR A PARTICULAR PURPOSE. The software and documentation provided hereunder
 - is on an "as is" basis, and Memorial Sloan-Kettering Cancer Center has no
 - obligations to provide maintenance, support, updates, enhancements or
 - modifications. In no event shall Memorial Sloan-Kettering Cancer Center be
 - liable to any party for direct, indirect, special, incidental or
 - consequential damages, including lost profits, arising out of the use of this
 - software and its documentation, even if Memorial Sloan-Kettering Cancer
 - Center has been advised of the possibility of such damage.
 --%>

<%--
 - This file is part of cBioPortal.
 -
 - cBioPortal is free software: you can redistribute it and/or modify
 - it under the terms of the GNU Affero General Public License as
 - published by the Free Software Foundation, either version 3 of the
 - License.
 -
 - This program is distributed in the hope that it will be useful,
 - but WITHOUT ANY WARRANTY; without even the implied warranty of
 - MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 - GNU Affero General Public License for more details.
 -
 - You should have received a copy of the GNU Affero General Public License
 - along with this program.  If not, see <http://www.gnu.org/licenses/>.
--%>

<%@ page import="org.mskcc.cbio.portal.util.GlobalProperties" %>
<%@ taglib prefix='c' uri='http://java.sun.com/jsp/jstl/core' %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%
    String principal = "";
    String authenticationMethod = GlobalProperties.authenticationMethod();
    pageContext.setAttribute("authenticationMethod", authenticationMethod);
    if (authenticationMethod.equals("openid") || authenticationMethod.equals("ldap")) {
        principal = "principal.name";
    }
    else if (authenticationMethod.equals("googleplus") ||
	    		authenticationMethod.equals("saml") ||
	    		authenticationMethod.equals("ad") ||
	    		authenticationMethod.equals("social_auth")) {
        principal = "principal.username";
    }
    pageContext.setAttribute("principal", principal);
%>
<%-- Calling static methods is not supported in all versions of EL without
     explicitly defining a function in an external taglib XML file. Using
     Spring's SpEL instead to keep it short for this one function call --%>
<s:eval var="rightLogo" expression="T(org.mskcc.cbio.portal.util.GlobalProperties).getRightLogo()"/>
<s:eval var="samlLogoutLocal" expression="T(org.mskcc.cbio.portal.util.GlobalProperties).getSamlIsLogoutLocal()"/>

<c:url var="samlLogoutUrl" value="/saml/logout">
    <c:param name="local" value="${samlLogoutLocal}" />
</c:url>

<style type="text/css">
.identity > a {
    color: #3786C2;
}

.identity .login {
    color: #3786C2;
    cursor: pointer;
}

.identity .login:hover{
    text-decoration: underline !important;
}
</style>

<script type="text/javascript">
function openSoicalAuthWindow() {
    var _window = open('login.jsp', '', 'width=1000, height=800');

    var interval = setInterval(function() {
        try {
            if (_window.closed) {
                clearInterval(interval);
            } else if (_window.document.URL.includes(location.origin) &&
                        !_window.document.URL.includes(location.origin + '/auth') &&
                        !_window.document.URL.includes('login.jsp')) {
                _window.close();

                setTimeout(function() {
                    clearInterval(interval);
                    if(window.location.pathname.includes('/study')) {
                        $('#rightHeaderContent').load(' #rightHeaderContent');
                        iViz.vue.manage.getInstance().showSaveButton= true
                    } else {
                        location.reload();
                    }
                }, 500);
            }
        } catch (err) {
            console.log('Error while monitoring the Login window: ', err);
        }
    }, 500);
};

</script>

<header>
        <div id="leftHeaderContent">
        <a id="cbioportal-logo" href="index.do"><img src="<c:url value="/images/cbioportal_occams_text_white.png"/>" alt="OCCAMS Logo" /></a>
        <div id="leftHeaderContentDescription">
          Oesophageal cancer clinical and molecular stratification (OCCAMS)
          <br />
          incorporating International Cancer Genome Consortium (ICGC)
        </div>
        </div>

        <div id="rightHeaderContent">
          <div id="rightHeaderPoweredByCBioPortal">
            <div id="rightHeaderPoweredByCBioPortalText">
              Powered by
            </div>
            <img src="<c:url value="/images/cbioportal_logo_txt_white.png"/>" alt="cBioPortal Logo" />
          </div>
        <%-- Display Sign Out Button for Real (Non-Anonymous) User --%>
        <sec:authorize access="!hasRole('ROLE_ANONYMOUS')">
            <div class="userControls">
            <span class="username"><i class="fa fa-cog" aria-hidden="true"></i></span>&nbsp;

                <div class="identity">Logged in as <sec:authentication property="${principal}" />&nbsp;|&nbsp;
                <c:choose>
                    <c:when test="${authenticationMethod == 'saml'}">
                        <a href="${samlLogoutUrl}">Sign out</a>
                    </c:when>
                    <c:otherwise>
                        <a href="j_spring_security_logout">Sign out</a>
                    </c:otherwise>
                </c:choose>
                &nbsp;&nbsp;
                <i class="fa fa-cog" aria-hidden="true"></i>
                </div>
            </div>
        </sec:authorize>

        <c:if test="${rightLogo != ''}">
            <img id="institute-logo" src="<c:url value="${rightLogo}"/>" alt="Institute Logo" />
        </c:if>
        </div>

    </header>
