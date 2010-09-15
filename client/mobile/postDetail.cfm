


<cfset dataError = false>
<cfset thisItem = listlast(cgi.path_info, "/")>

<cftry>
	<cfset entryData = application.blog.getEntry(thisItem)>
	<cfset comments = application.blog.getComments(thisItem)>
	
	<!---catch an attept to load an unreleased entry--->
	<cfif NOT entryData.released>
		<cfset dataError = true>	
	</cfif>
	
<cfcatch type="any">
	<cfset dataError = true>
</cfcatch>

</cftry>


<cfoutput>
	<div id="#hash(thisItem)#">
	    <div class="toolbar">
	        <h1>Post Detail</h1>
	        <a class="button back" href="##">Back</a>
	    </div>
	
		<cfif dataError>
		
			<div class="body">
				There was an error attempting to load the post.
			</div>
		<cfelse>
			<div class="body">
				<p style="font-size:12px;">
				
				<span style="font-size: 14px;">#entryData.title#</span><br><br>
				<strong>Posted:</strong> #application.localeUtils.dateLocaleFormat(entryData.posted)# #application.localeUtils.timeLocaleFormat(entryData.posted)# <strong>By:</strong> #entryData.name#
				<BR>
				<strong>Categories:</strong> 
				<cfset lastid = listLast(structKeyList(entryData.categories))>
				<cfloop item="catid" collection="#entryData.categories#">
					#entryData.categories[catid]#<cfif catid is not lastid>, </cfif>
				</cfloop>
				
				</p>
			</div>
			
			<div style="padding: 10px 10px 0 10px;">
			
				<div>
					<!---
						pre render rereplace is here to correct rendering issue caused by the renderer
					--->
					#application.blog.renderEntry(REReplace("<p>" & entryData.body & "</p>", "\r+\n\r+\n", "</p><BR><p>", "ALL"),true,'', true)#
					<BR>
					#application.blog.renderEntry(REReplace("<p>" & entryData.morebody & "</p>", "\r+\n\r+\n", "</p><BR><p>", "ALL"),true,'', true)#
				</div>	
				
			</div>
			
		
			<cfif comments.recordCount>
			<ul class="edgetoedge" >	
				<li style="text-align: center;">Comments</li>
			</ul>
			<ul class="edgetoedge">
				<cfloop query="comments">
					<li class="sep" style="font-size: 14px;">
					<cfif application.gravatarsAllowed><img src="http://www.gravatar.com/avatar/#lcase(hash(comments.email))#?s=40&amp;r=pg&amp;d=#application.rooturl#/images/gravatar.png" alt="#comments.name#'s Gravatar" border="0" align="left" style="padding-right: 5px;" /></cfif>
					#comments.name# 
					<cfif application.gravatarsAllowed><BR><cfelse> - </cfif>
					#application.localeUtils.dateLocaleFormat(comments.posted)# #application.localeUtils.timeLocaleFormat(comments.posted)#</li>
					<li style="font-size: 13px;">
						<p>
							#paragraphFormat2(replaceLinks(comments.comment))#
						</p>
					</li>			
				</cfloop>
			</ul>
			</cfif>
		</cfif>
	</div>

</cfoutput>