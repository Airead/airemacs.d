<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><head><title>EmacsWiki: outline+.el</title><link rel="alternate" type="application/wiki" title="Edit this page" href="http://www.emacswiki.org/emacs?action=edit;id=outline%2b.el" />
<link type="text/css" rel="stylesheet" href="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.3.0/css/bootstrap-combined.min.css" />
<link type="text/css" rel="stylesheet" href="/css/bootstrap.css" />
<meta name="robots" content="INDEX,FOLLOW" /><link rel="alternate" type="application/rss+xml" title="EmacsWiki" href="http://www.emacswiki.org/emacs?action=rss" /><link rel="alternate" type="application/rss+xml" title="EmacsWiki: outline+.el" href="http://www.emacswiki.org/emacs?action=rss;rcidonly=outline%2b.el" />
<link rel="alternate" type="application/rss+xml"
      title="Emacs Wiki with page content"
      href="http://www.emacswiki.org/emacs/full.rss" />
<link rel="alternate" type="application/rss+xml"
      title="Emacs Wiki with page content and diff"
      href="http://www.emacswiki.org/emacs/full-diff.rss" />
<link rel="alternate" type="application/rss+xml"
      title="Emacs Wiki including minor differences"
      href="http://www.emacswiki.org/emacs/minor-edits.rss" />
<link rel="alternate" type="application/rss+xml"
      title="Changes for outline+.el only"
      href="http://www.emacswiki.org/emacs?action=rss;rcidonly=outline%2b.el" /><meta name="viewport" content="width=device-width" />
<script type="text/javascript" src="/outliner.0.5.0.62-toc.js"></script>
<script type="text/javascript">

  function addOnloadEvent(fnc) {
    if ( typeof window.addEventListener != "undefined" )
      window.addEventListener( "load", fnc, false );
    else if ( typeof window.attachEvent != "undefined" ) {
      window.attachEvent( "onload", fnc );
    }
    else {
      if ( window.onload != null ) {
	var oldOnload = window.onload;
	window.onload = function ( e ) {
	  oldOnload( e );
	  window[fnc]();
	};
      }
      else
	window.onload = fnc;
    }
  }

  var initToc=function() {

    var outline = HTML5Outline(document.body);
    if (outline.sections.length == 1) {
      outline.sections = outline.sections[0].sections;
    }

    if (outline.sections.length > 1
	|| outline.sections.length == 1
           && outline.sections[0].sections.length > 0) {

      var toc = document.getElementById('toc');

      if (!toc) {
	var divs = document.getElementsByTagName('div');
	for (var i = 0; i < divs.length; i++) {
	  if (divs[i].getAttribute('class') == 'toc') {
	    toc = divs[i];
	    break;
	  }
	}
      }

      if (!toc) {
	var h2 = document.getElementsByTagName('h2')[0];
	if (h2) {
	  toc = document.createElement('div');
	  toc.setAttribute('class', 'toc');
	  h2.parentNode.insertBefore(toc, h2);
	}
      }

      if (toc) {
        var html = outline.asHTML(true);
        toc.innerHTML = html;
      }
    }
  }

  addOnloadEvent(initToc);
  </script>

<script src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
<script src="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.3.0/js/bootstrap.min.js"></script>
<script src="http://emacswiki.org/emacs/emacs-bootstrap.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /></head><body class="http://www.emacswiki.org/emacs"><div class="header"><span class="gotobar bar"><a class="local" href="http://www.emacswiki.org/emacs/SiteMap">SiteMap</a> <a class="local" href="http://www.emacswiki.org/emacs/Search">Search</a> <a class="local" href="http://www.emacswiki.org/emacs/ElispArea">ElispArea</a> <a class="local" href="http://www.emacswiki.org/emacs/HowTo">HowTo</a> <a class="local" href="http://www.emacswiki.org/emacs/Glossary">Glossary</a> <a class="local" href="http://www.emacswiki.org/emacs/RecentChanges">RecentChanges</a> <a class="local" href="http://www.emacswiki.org/emacs/News">News</a> <a class="local" href="http://www.emacswiki.org/emacs/Problems">Problems</a> <a class="local" href="http://www.emacswiki.org/emacs/Suggestions">Suggestions</a> </span><br /><span class="specialdays">Peru, Independence Day</span><h1><a title="Click to search for references to this page" rel="nofollow" href="http://www.emacswiki.org/emacs?search=%22outline%2b%5c.el%22">outline+.el</a></h1></div><div class="wrapper"><div class="content browse"><p class="download"><a href="http://www.emacswiki.org/emacs-en/download/outline%2b.el">Download</a></p><pre class="code"><span class="linecomment">;;; outline+.el --- Extensions to `outline.el'.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; Filename: outline+.el</span>
<span class="linecomment">;; Description: Extensions to `outline.el'.</span>
<span class="linecomment">;; Author: Drew Adams</span>
<span class="linecomment">;; Maintainer: Drew Adams</span>
<span class="linecomment">;; Copyright (C) 1996-2013, Drew Adams, all rights reserved.</span>
<span class="linecomment">;; Created: Fri Jun 21 08:56:04 1996</span>
<span class="linecomment">;; Version: 20.0</span>
<span class="linecomment">;; Last-Updated: Fri Dec 28 10:17:09 2012 (-0800)</span>
<span class="linecomment">;;           By: dradams</span>
<span class="linecomment">;;     Update #: 334</span>
<span class="linecomment">;; URL: http://www.emacswiki.org/outline+.el</span>
<span class="linecomment">;; Keywords: abbrev, matching, local</span>
<span class="linecomment">;; Compatibility: GNU Emacs 20.x</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; Features that might be required by this library:</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;   `outline'.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;; Commentary:</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;    Extensions to `outline.el'.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;  Menu bar:</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;  Reordered and renamed menu bar Outline Mode Hide and Show menus.</span>
<span class="linecomment">;;  Names of menu items now indicate whether the item applies locally</span>
<span class="linecomment">;;  or globally.  Global and local items are separated in the menu.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;      Renamings:</span>
<span class="linecomment">;;        Hide Leaves    -&gt; Hide Entries                (local)</span>
<span class="linecomment">;;        Hide Body      -&gt; Hide All But Headings       (global)</span>
<span class="linecomment">;;        Hide Subtree   -&gt; Hide Tree                   (local)</span>
<span class="linecomment">;;        Hide Sublevels -&gt; Hide All But Top N Headings (global)</span>
<span class="linecomment">;;        Hide Other     -&gt; Hide All But Entry          (local)</span>
<span class="linecomment">;;        Show Branches  -&gt; Show Headings               (local)</span>
<span class="linecomment">;;        Show Children  -&gt; Show Headings N Deep        (local)</span>
<span class="linecomment">;;        Show Subtree   -&gt; Show Tree                   (local)</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;  Outline minor mode font locking:</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;     See the new command `toggle-outline-minor-mode-font-lock',</span>
<span class="linecomment">;;     intended for use as both `outline-minor-mode-hook' and</span>
<span class="linecomment">;;     `outline-minor-mode-exit-hook'.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;  New function defined here: `toggle-outline-minor-mode-font-lock'.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;  New variables defined here:</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;     Var `outline-minor-mode-hook' was not declared in `outline.el'.</span>
<span class="linecomment">;;     It is declared here, along with `outline-minor-mode-exit-hook'.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;  ***** NOTE: The following function defined in `vc.el' has been</span>
<span class="linecomment">;;              REDEFINED HERE:</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;  `outline-minor-mode' - Call to `outline-minor-mode-exit-hook'.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;  This file should be loaded after loading the standard GNU file</span>
<span class="linecomment">;;  `outline.el'.  So, in your `~/.emacs' file, do this:</span>
<span class="linecomment">;;  (eval-after-load "outline" '(progn (require 'outline+))</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;; Change Log:</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; 2011/01/04 dadams</span>
<span class="linecomment">;;     Removed autoload cookies from defvar.</span>
<span class="linecomment">;; 2006/03/30 dadams</span>
<span class="linecomment">;;     No longer use display-in-minibuffer.</span>
<span class="linecomment">;; 2005/12/30 dadams</span>
<span class="linecomment">;;     Added: minibuffer-prompt face.  Removed blue-foreground-face.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; This program is free software; you can redistribute it and/or modify</span>
<span class="linecomment">;; it under the terms of the GNU General Public License as published by</span>
<span class="linecomment">;; the Free Software Foundation; either version 2, or (at your option)</span>
<span class="linecomment">;; any later version.</span>

<span class="linecomment">;; This program is distributed in the hope that it will be useful,</span>
<span class="linecomment">;; but WITHOUT ANY WARRANTY; without even the implied warranty of</span>
<span class="linecomment">;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the</span>
<span class="linecomment">;; GNU General Public License for more details.</span>

<span class="linecomment">;; You should have received a copy of the GNU General Public License</span>
<span class="linecomment">;; along with this program; see the file COPYING.  If not, write to</span>
<span class="linecomment">;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth</span>
<span class="linecomment">;; Floor, Boston, MA 02110-1301, USA.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;; Code:</span>

(require 'outline)
(and (&lt; emacs-major-version 20) (eval-when-compile (require 'cl))) <span class="linecomment">;; when</span>

<span class="linecomment">;;; You will get this:</span>
<span class="linecomment">;;;</span>
<span class="linecomment">;;; Compiling file outline+.el</span>
<span class="linecomment">;;;   ** the function outline-mode-font-lock-keywords is not known to be defined.</span>

<span class="linecomment">;;;;;;;;;;;;;;;;;;;;</span>


<span class="linecomment">;; This is defined in `faces.el', Emacs 22.  This definition is adapted to Emacs 20.</span>
(unless (facep 'minibuffer-prompt)
  (defface minibuffer-prompt '((((background dark)) (:foreground "<span class="quote">cyan</span>"))
                               (t (:foreground "<span class="quote">dark blue</span>")))
    "<span class="quote">Face for minibuffer prompts.</span>"
    :group 'basic-faces))

(defvar outline-minor-mode-exit-hook nil
  "<span class="quote">*Functions to be called when `outline-minor-mode' is exited.</span>")

(defvar outline-minor-mode-hook nil
  "<span class="quote">*Functions to be called when `outline-minor-mode' is entered.</span>")


<span class="linecomment">;; REPLACES ORIGINAL in `outline.el':</span>
<span class="linecomment">;; Added `outline-minor-mode-exit-hook'.</span>
<span class="linecomment">;;;###autoload</span>
(defun outline-minor-mode (&optional arg)
  "<span class="quote">Toggle Outline minor mode.
Non-nil prefix ARG turns mode on if ARG is positive, else turns off.
Runs `outline-minor-mode-hook' when Outline minor mode is entered.
Runs `outline-minor-mode-exit-hook' when Outline minor mode is exited.
See the command `outline-mode' for more information on this mode.</span>"
  (interactive "<span class="quote">P</span>")
  (setq outline-minor-mode (if (null arg)
                               (not outline-minor-mode)
                             (&gt; (prefix-numeric-value arg) 0)))
  (setq selective-display outline-minor-mode)
  (if outline-minor-mode
      (run-hooks 'outline-minor-mode-hook)
    <span class="linecomment">;; Show all lines, getting rid of any ^M's.</span>
    (outline-flag-region (point-min) (point-max) ?\n)
    (run-hooks 'outline-minor-mode-exit-hook))
  (set-buffer-modified-p (buffer-modified-p)))

<span class="linecomment">;;;###autoload</span>
(defun toggle-outline-minor-mode-font-lock ()
  "<span class="quote">Toggle `font-lock-mode' for Outline minor mode.
Usable as `outline-minor-mode-hook' & `outline-minor-mode-exit-hook'.

As `outline-minor-mode-hook':
Highlight according to Outline minor mode.  If already highlit
according to some other mode, then require confirmation first.

As `outline-minor-mode-exit-hook':
Remove Outline minor mode highlighting, if any.
Then, upon confirmation, rehighlight according to the major mode.</span>"
  (interactive)
  (let* ((outline-keywords (and (fboundp 'outline-mode-font-lock-keywords)
                                (outline-mode-font-lock-keywords)))
         (outline-keywords-p (equal font-lock-keywords outline-keywords)))
    (if outline-minor-mode
        <span class="linecomment">;; Assume ENTERING outline minor mode.</span>
        (when (and (not outline-keywords-p) <span class="linecomment">; Not already outline keywords.</span>
                   (or (not font-lock-mode) <span class="linecomment">; OK to use outline highlighting.</span>
                       (y-or-n-p "<span class="quote">Use outline-minor-mode highlighting? </span>")))
          (setq font-lock-keywords outline-keywords)
          <span class="linecomment">;;;@@@Emacs20 (setq font-lock-no-comments t)</span>
          (font-lock-mode -999)         <span class="linecomment">; Remove existing highlighting.</span>
          (font-lock-mode 999))
      <span class="linecomment">;; Assume EXITING outline minor mode.</span>
      (when (and font-lock-mode outline-keywords-p) <span class="linecomment">;  Outline highlit.</span>
        (setq font-lock-keywords nil)   <span class="linecomment">; Reset keywords to those of major mode</span>
        (font-lock-set-defaults)
        (font-lock-mode -999)           <span class="linecomment">; Remove existing highlighting.</span>
        (when (y-or-n-p (format "<span class="quote">Turn Font Lock mode ON in mode %s? </span>"
                                mode-name))
          (font-lock-mode 999))))
    (message "<span class="quote">Outline minor mode is now %s.</span>" (if outline-minor-mode "<span class="quote">ON</span>" "<span class="quote">OFF</span>"))))



<span class="linecomment">;; Outline mode menu-bar menu.</span>

(define-key outline-mode-menu-bar-map [hide]
  (cons "<span class="quote">Hide</span>" (make-sparse-keymap "<span class="quote">Hide</span>")))

(define-key outline-mode-menu-bar-map [hide hide-sublevels]
  '("<span class="quote">Hide All But Top N Headings (global)</span>" . hide-sublevels))
(define-key outline-mode-menu-bar-map [hide hide-body]
  '("<span class="quote">Hide All But Headings       (global)</span>" . hide-body))
(define-key outline-mode-menu-bar-map [hide hide-separator] '("<span class="quote">--</span>"))
(define-key outline-mode-menu-bar-map [hide hide-other]
  '("<span class="quote">Hide All But Entry          (local)</span>" . hide-other))
(define-key outline-mode-menu-bar-map [hide hide-entry]
  '("<span class="quote">Hide Entry                  (local)</span>" . hide-entry))
(define-key outline-mode-menu-bar-map [hide hide-leaves]
  '("<span class="quote">Hide Entries                (local)</span>" . hide-leaves))
(define-key outline-mode-menu-bar-map [hide hide-subtree]
  '("<span class="quote">Hide Tree                   (local)</span>" . hide-subtree))

(define-key outline-mode-menu-bar-map [show]
   (cons "<span class="quote">Show</span>" (make-sparse-keymap "<span class="quote">Show</span>")))

(define-key outline-mode-menu-bar-map [show show-all]
  '("<span class="quote">Show All             (global)</span>" . show-all))
(define-key outline-mode-menu-bar-map [show show-separator] '("<span class="quote">--</span>"))
(define-key outline-mode-menu-bar-map [show show-entry]
  '("<span class="quote">Show Entry           (local)</span>" . show-entry))
(define-key outline-mode-menu-bar-map [show show-children]
  '("<span class="quote">Show Headings N Deep (local)</span>" . show-children))
(define-key outline-mode-menu-bar-map [show show-branches]
  '("<span class="quote">Show Headings        (local)</span>" . show-branches))
(define-key outline-mode-menu-bar-map [show show-subtree]
  '("<span class="quote">Show Tree            (local)</span>" . show-subtree))

<span class="linecomment">;;;;;;;;;;;;;;;;;;;;;;;</span>

(provide 'outline+)

<span class="linecomment">;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;</span>
<span class="linecomment">;;; outline+.el ends here</span></span></pre></div><div class="wrapper close"></div></div><div class="footer"><hr /><span class="gotobar bar"><a class="local" href="http://www.emacswiki.org/emacs/SiteMap">SiteMap</a> <a class="local" href="http://www.emacswiki.org/emacs/Search">Search</a> <a class="local" href="http://www.emacswiki.org/emacs/ElispArea">ElispArea</a> <a class="local" href="http://www.emacswiki.org/emacs/HowTo">HowTo</a> <a class="local" href="http://www.emacswiki.org/emacs/Glossary">Glossary</a> <a class="local" href="http://www.emacswiki.org/emacs/RecentChanges">RecentChanges</a> <a class="local" href="http://www.emacswiki.org/emacs/News">News</a> <a class="local" href="http://www.emacswiki.org/emacs/Problems">Problems</a> <a class="local" href="http://www.emacswiki.org/emacs/Suggestions">Suggestions</a> </span><span class="translation bar"><br />  <a class="translation new" rel="nofollow" href="http://www.emacswiki.org/emacs?action=translate;id=outline+.el;missing=de_es_fr_it_ja_ko_pt_ru_se_zh">Add Translation</a></span><span class="edit bar"><br /> <a class="comment local" accesskey="c" href="http://www.emacswiki.org/emacs/Comments_on_outline%2b.el">Comments on outline+.el</a> <a class="edit" accesskey="e" title="Click to edit this page" rel="nofollow" href="http://www.emacswiki.org/emacs?action=edit;id=outline%2b.el">Edit this page</a> <a class="history" rel="nofollow" href="http://www.emacswiki.org/emacs?action=history;id=outline%2b.el">View other revisions</a> <a class="admin" rel="nofollow" href="http://www.emacswiki.org/emacs?action=admin;id=outline%2b.el">Administration</a></span><span class="time"><br /> Last edited 2012-12-28 19:36 UTC by <a class="author" title="from inet-rmmc01-o.oracle.com" href="http://www.emacswiki.org/emacs/DrewAdams">DrewAdams</a> <a class="diff" rel="nofollow" href="http://www.emacswiki.org/emacs?action=browse;diff=2;id=outline%2b.el">(diff)</a></span><form method="get" action="http://www.emacswiki.org/cgi-bin/emacs" enctype="multipart/form-data" accept-charset="utf-8" class="search">
<p><label for="search">Search:</label> <input type="text" name="search"  size="20" accesskey="f" id="search" /> <label for="searchlang">Language:</label> <input type="text" name="lang"  size="10" id="searchlang" /> <input type="submit" name="dosearch" value="Go!" /></p></form><div style="float:right; margin-left:1ex;">
<!-- Creative Commons License -->
<a class="licence" href="http://creativecommons.org/licenses/GPL/2.0/"><img alt="CC-GNU GPL" style="border:none" src="/pics/cc-GPL-a.png" /></a>
<!-- /Creative Commons License -->
</div>

<!--
<rdf:RDF xmlns="http://web.resource.org/cc/"
 xmlns:dc="http://purl.org/dc/elements/1.1/"
 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<Work rdf:about="">
   <license rdf:resource="http://creativecommons.org/licenses/GPL/2.0/" />
  <dc:type rdf:resource="http://purl.org/dc/dcmitype/Software" />
</Work>

<License rdf:about="http://creativecommons.org/licenses/GPL/2.0/">
   <permits rdf:resource="http://web.resource.org/cc/Reproduction" />
   <permits rdf:resource="http://web.resource.org/cc/Distribution" />
   <requires rdf:resource="http://web.resource.org/cc/Notice" />
   <permits rdf:resource="http://web.resource.org/cc/DerivativeWorks" />
   <requires rdf:resource="http://web.resource.org/cc/ShareAlike" />
   <requires rdf:resource="http://web.resource.org/cc/SourceCode" />
</License>
</rdf:RDF>
-->

<p class="legal">
This work is licensed to you under version 2 of the
<a href="http://www.gnu.org/">GNU</a> <a href="/GPL">General Public License</a>.
Alternatively, you may choose to receive this work under any other
license that grants the right to use, copy, modify, and/or distribute
the work, as long as that license imposes the restriction that
derivative works have to grant the same rights and impose the same
restriction. For example, you may choose to receive this work under
the
<a href="http://www.gnu.org/">GNU</a>
<a href="/FDL">Free Documentation License</a>, the
<a href="http://creativecommons.org/">CreativeCommons</a>
<a href="http://creativecommons.org/licenses/sa/1.0/">ShareAlike</a>
License, the XEmacs manual license, or
<a href="/OLD">similar licenses</a>.
</p>
</div>
</body>
</html>
