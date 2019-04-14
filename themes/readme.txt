READ ME

Product: SharePoint(TM) Team Services from Microsoft® Sample Site Package: Education High School
	In these instructions and in Microsoft® FrontPage®, this may be referred to
	as "SharePoint Education High School."

Description: How to get your SharePoint Team Services-based site 
	to look like the SharePoint Team Services Sample Site: Education High School

Requirements: You must already have a SharePoint Team Services-based 
	site on a server. It's best if you begin with a brand new 
	SharePoint-based web with no modifications made yet. You must 
	use FrontPage Version 2002.
	
-------------------------------------------------------------------
Getting Started - Installation
-------------------------------------------------------------------
The zip file contains folders with images and other web files, as
well as an installer (.exe) that will install the Theme. Run the
installer by double-clicking on it and following the prompts. 
Unzip the other files and place them on your computer somewhere 
where you can find them again, being sure to preserve the folder
structure.
	
-------------------------------------------------------------------
Step 1
-------------------------------------------------------------------
Open your web live off the server.

	1. Open FrontPage.
	2. Go to File > Open Web.
	3. Type in the URL of your SharePoint web in the folder field,
	   for example, "http://www.yoursite.com/sharepoint"
	4. Click OK. FrontPage will attempt to open your web. Type in
	   your user/password information if necessary.
	   
	*Tip: Preview your web in a browser as you work on it.
	   Go to File > Preview in Browser and choose Internet 
	   Explorer, then click OK. IE will open with your
	   web page open. You should refresh often as you edit 
	   your site to see what they look like "live."
	   
-------------------------------------------------------------------
Step 2
-------------------------------------------------------------------
Apply the "SharePoint Education High School" FrontPage Theme.

	1. With your web open, go to Format > Theme.
	2. The Theme dialog box will open. Select the 
	   "SharePoint Education High School." Select the "All pages"
	   option and "Vivid Colors," "Active Graphics," and "Apply
	   Using CSS" checkboxes. Click OK. When the dialog box opens
	   that says, "Applying a theme to a web will permanently replace
	   existing formatting information. Individually themed pages will
	   not be modified. Do you want to apply the theme?" Click Yes
	   to continue. FrontPage will apply the Theme.
	3. When FrontPage is done working, you will notice that text
	   and some other colors have changed.
	   
-------------------------------------------------------------------
Step 3
-------------------------------------------------------------------
Show hidden files in your web.

	1. In your open web, go to Tools > Web Settings.
	2. Click the Advanced Tab.
	3. Check the "show hidden files and folders" option.
	4. Click OK.
	5. When asked whether or not you want to refresh your web,
	   click Yes.  You will now notice that 
	   additional folders now appear in your Folder List.
	   
	

-------------------------------------------------------------------
Step 4
-------------------------------------------------------------------
Import images.

	1. Click on the "images" (in the root folder...not in _layouts)
	   folder in your web to select it.
	2. Go to File > Import. Click "Add File."
	3. Browse to the folder called "images" from the zip.
	4. Type Ctrl-A to select all the files:
		highschoolonline.gif
		collage.jpg
		announcements.gif
		quicklaunch.gif
		researchlinks.gif
		soccer.jpg
		thisweeksevents.gif
		trans.gif
	5. Click "Open" to add them to your imported files list. Make
	   sure that they are going to be written into your "images"
	   folder. (The URL should look like: "images/button.gif".)
	6. Click "OK" to import them into you web.

-------------------------------------------------------------------
Step 5
-------------------------------------------------------------------
Add top and bottom shared borders.

	1. In FrontPage with your Web site open, go to Format > Shared 
	   Borders.
	2. Select "All Pages" and check the "top" and "bottom" borders.
	3. Click OK. FrontPage will add the top and bottom shared
	   border areas to your page. You will see white content areas
	   at the bottom and top of your pages. You will also see a
	   new "_borders" folder in your web. Close any open pages 
	   in FrontPage.
	4. Click on the "_borders" folder in your web to select it.
	5. Double-click on "top.htm" to open it.
	6. Now, go to your zip folder and open the "borders" folder.
	   Open "top-page.txt" in a text editor like Notepad. Select all
	   the text by typing Ctrl-A. Now Copy the text by
	   typing Ctrl-C.
	7. Switch back to FrontPage. Go to HTML view of top.htm. Type Ctrl-A to 
	   select all the HTML in your "top.htm" page. Paste the text 
	   by typing Ctrl-V. Save your document.
	8. Repeat the steps with "bottom.htm" in your web and 
	   "bottom-page.txt" in the borders folder. Open "bottom.htm"
	   in FrontPage's HTML view and "bottom-page.txt" in a text 
	   editor. Copy the text from the "bottom-page.txt" and replace
	   the HTML code in "bottom.htm" and save.
	9. You can close top.htm and bottom.htm.
	   

--------------------------------------------------------------------
Step 6
--------------------------------------------------------------------
Modify home page. (Optional)
We advise that you stick to modifications of your home page that
only use the "Web Settings" on your default SharePoint Team 
Services-based site's link bar. You may use FrontPage to add your logos
into the page in place of the SharePoint logos. However, if you want to 
get a home page that looks like the High School sample site that was created
with Sharepoint Team Services, follow these steps.

Please note that this is for advanced users who are comfortable 
with using FrontPage.


Step I: Configure existing home page.

	First, make sure that you have your home page configured with the
	lists that you want. The default view has "Announcements," "Events,"
	and "Links."
	
	You can configure your home page by opening your SharePoint Team
	Services-based site in a browser (File > Preview in Browser). Click
	"Create" on the site's link bar to make more lists.

	Then, click "Site Settings" from the main navigation bar and 
	then click "Customize Home Page Layout." Drag any additional lists
	that you want on your home page into the different columns.
	
Step II: Turn off Shared Borders on home page.
	
	Open your Home Page in FrontPage by double-clicking on it and go to 
	Format > Shared Borders. Click the "Current page only" option, then 
	uncheck the "top" and "bottom" shared border options. Click OK, then 
	save your home page.
	
	
Step III: Change home page layout to new home page layout.


	1. Make a backup copy of your home page. With the FrontPage web
	   site, you created with SharePoint Team Services, open
	   right-click on the "index.htm" page (or default.htm, etc.)
	   that has the home icon. Choose "Copy". Now right-click and 
	   choose "Paste" to make a copy of the home page into your web.
	2. In Notepad, open the "homepage.txt" file from your zip file.
	   Select all the text (Ctrl-A) and copy (Ctrl-C).
	3. Go back to FrontPage and open the home page by 
	   double-clicking on it.
	4. Switch to HTML View. Find the line of code that starts
	   with <BODY marginwidth="0" marginheight="0"... > 
	5. Carriage return after that line and paste (Ctrl-V) your
	   copied code into the HTML view. Save your page.
	6. Go back to Page View. You will see the complex layout
	   from the Sharepoint Team Services sample site 
	   on the top half of your page, and your old page layout on 
	   the bottom of the page.
	7. The bottom half will show the existing Announcements, Links,
	   Events, etc. sections. Click on them and drag them into the new
	   top half of the page. Delete the text that says
	   "Drag your list here." 
	8. Now, delete the bottom half of the page. Click in the bottom table
	   and drag across to select the cells. Then hit the delete key.
	   Delete any extra spaces between the bottom of the new table
	   and the shared border.
	9. You will want to change the way your lists are displayed on 
	   the home page so that they do not have the list title. Right-click
	   on each list and got to View Properties. Click on the Options
	   button. In the "Toolbar Type" dropdown menu, select "None" and
	   click OK. Click OK again. In the same "List View Properties" screen
	   you can go to "Fields..." and add the edit and/or body field if you like.
	   Do this to all of your home page lists.
	


	   
----------------------------------------------------------------------
Congratulations! You may now open your SharePoint Team Services-based 
site to your team and begin adding announcements, lists, and much more!
	
	   