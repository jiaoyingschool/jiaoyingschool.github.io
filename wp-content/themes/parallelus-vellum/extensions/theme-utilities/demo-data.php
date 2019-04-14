<?php

# ==================================================
# Setup and install demo content
# ==================================================

if ( ! function_exists( 'theme_demo_data' ) ) :
	function theme_demo_data() {
		global $shortname;


		# --------------------------------------------------
		# Theme Options
		# --------------------------------------------------

		// Row => Data  (doesn't include $shortname prefix)
		$demo_data = array(

			/*
			'contact_fields' => 
				'YToyOntzOjY6ImZpZWxkcyI7YTozOntzOjQ6Im5hbWUiO2E6MTI6e3M6NToibGFiZWwiO3M6NDoiTmFtZSI7czo1OiJhbGlhcyI7czo0OiJuYW1lIjtzOjc6ImNhcHRpb24iO3M6MjM6IlBsZWFzZSBlbnRlciB5b3VyIG5hbWUuIjtzOjEwOiJmaWVsZF90eXBlIjtzOjQ6InRleHQiO3M6NjoidmFsdWVzIjtzOjA6IiI7czo4OiJyZXF1aXJlZCI7czoxOiIwIjtzOjE0OiJlcnJvcl9yZXF1aXJlZCI7czowOiIiO3M6OToibWlubGVuZ3RoIjtzOjA6IiI7czo5OiJtYXhsZW5ndGgiO3M6MDoiIjtzOjEwOiJ2YWxpZGF0aW9uIjtzOjA6IiI7czoxNjoiZXJyb3JfdmFsaWRhdGlvbiI7czowOiIiO3M6NDoic2l6ZSI7YToyOntzOjU6IndpZHRoIjtzOjA6IiI7czo2OiJoZWlnaHQiO3M6MDoiIjt9fXM6NToiZW1haWwiO2E6MTI6e3M6NToibGFiZWwiO3M6NToiRW1haWwiO3M6NToiYWxpYXMiO3M6NToiZW1haWwiO3M6NzoiY2FwdGlvbiI7czoxOToiWW91ciBlbWFpbCBhZGRyZXNzLiI7czoxMDoiZmllbGRfdHlwZSI7czo0OiJ0ZXh0IjtzOjY6InZhbHVlcyI7czowOiIiO3M6ODoicmVxdWlyZWQiO3M6MToiMSI7czoxNDoiZXJyb3JfcmVxdWlyZWQiO3M6MDoiIjtzOjk6Im1pbmxlbmd0aCI7czowOiIiO3M6OToibWF4bGVuZ3RoIjtzOjA6IiI7czoxMDoidmFsaWRhdGlvbiI7czowOiIiO3M6MTY6ImVycm9yX3ZhbGlkYXRpb24iO3M6MDoiIjtzOjQ6InNpemUiO2E6Mjp7czo1OiJ3aWR0aCI7czowOiIiO3M6NjoiaGVpZ2h0IjtzOjA6IiI7fX1zOjc6Im1lc3NhZ2UiO2E6MTI6e3M6NToibGFiZWwiO3M6NzoiTWVzc2FnZSI7czo1OiJhbGlhcyI7czo3OiJtZXNzYWdlIjtzOjc6ImNhcHRpb24iO3M6Mjk6IlRoZSBtZXNzYWdlIHlvdSB3aXNoIHRvIHNlbmQuIjtzOjEwOiJmaWVsZF90eXBlIjtzOjg6InRleHRhcmVhIjtzOjY6InZhbHVlcyI7czowOiIiO3M6ODoicmVxdWlyZWQiO3M6MToiMSI7czoxNDoiZXJyb3JfcmVxdWlyZWQiO3M6MDoiIjtzOjk6Im1pbmxlbmd0aCI7czowOiIiO3M6OToibWF4bGVuZ3RoIjtzOjA6IiI7czoxMDoidmFsaWRhdGlvbiI7czowOiIiO3M6MTY6ImVycm9yX3ZhbGlkYXRpb24iO3M6MDoiIjtzOjQ6InNpemUiO2E6Mjp7czo1OiJ3aWR0aCI7czowOiIiO3M6NjoiaGVpZ2h0IjtzOjA6IiI7fX19czo4OiJkZWZhdWx0cyI7YTo1OntzOjI6InRvIjtzOjIxOiJibGFja2hvbGVAZXhhbXBsZS5jb20iO3M6Nzoic3ViamVjdCI7czoyMzoiVGhpcyBpcyBhIHRlc3QgbWVzc2FnZS4iO3M6ODoidGhhbmt5b3UiO3M6MjU6IlRoYW5rcyBmb3IgY29udGFjdGluZyB1cyEiO3M6NjoiYnV0dG9uIjtzOjEyOiJTZW5kIE1lc3NhZ2UiO3M6NzoiY2FwdGNoYSI7czoxOiIxIjt9fQ==',
					
			'options-page' => 
				'YTo1Njp7czoxMToiZmllbGRfdHlwZXMiO2E6NTE6e3M6MTA6ImxvZ28taW1hZ2UiO3M6MTU6ImZpbGV1cGxvYWQtdHlwZSI7czoxMDoibG9nby13aWR0aCI7czoxMDoiaW5wdXQtdGV4dCI7czo4OiJsb2dvLXVybCI7czoxMDoiaW5wdXQtdGV4dCI7czoxMDoibG9nby10aXRsZSI7czoxMDoiaW5wdXQtdGV4dCI7czoxNDoiZmF2b3JpdGVzLWljb24iO3M6MTU6ImZpbGV1cGxvYWQtdHlwZSI7czoxNToibW9iaWxlLWJvb2ttYXJrIjtzOjE1OiJmaWxldXBsb2FkLXR5cGUiO3M6MTI6ImxheW91dC1zdHlsZSI7czoxMToic2VsZWN0LXR5cGUiO3M6NDoic2tpbiI7czoxMToic2VsZWN0LXR5cGUiO3M6MTI6ImRlc2lnbi13aWR0aCI7czoxMDoiaW5wdXQtdGV4dCI7czoxNjoiY29udGVudC1wb3NpdGlvbiI7czoxMToic2VsZWN0LXR5cGUiO3M6MTM6Im1hc3RoZWFkLXNpemUiO3M6MTE6InNlbGVjdC10eXBlIjtzOjE0OiJhY2NlbnQtY29sb3ItMSI7czoxNjoiY29sb3JwaWNrZXItdHlwZSI7czoyMDoiaW1hZ2Utb3ZlcmxheS1lZmZlY3QiO3M6MTE6InNlbGVjdC10eXBlIjtzOjE0OiJkb2NrLW9uLXNjcm9sbCI7czoxODoiY2hlY2tib3gtYm9vbC10eXBlIjtzOjE2OiJzaG93LWJyZWFkY3J1bWJzIjtzOjE4OiJjaGVja2JveC1ib29sLXR5cGUiO3M6MTY6InNtb290aC1zY3JvbGxpbmciO3M6MTE6InNlbGVjdC10eXBlIjtzOjEwOiJsaW5rLWNvbG9yIjtzOjE2OiJjb2xvcnBpY2tlci10eXBlIjtzOjE2OiJsaW5rLWhvdmVyLWNvbG9yIjtzOjE2OiJjb2xvcnBpY2tlci10eXBlIjtzOjEzOiJlcnJvci1jb250ZW50IjtzOjExOiJzZWxlY3QtdHlwZSI7czoyNToibWFzdGhlYWQtYmFja2dyb3VuZC1jb2xvciI7czoxNjoiY29sb3JwaWNrZXItdHlwZSI7czoyNToibWFzdGhlYWQtYmFja2dyb3VuZC1pbWFnZSI7czoxNToiZmlsZXVwbG9hZC10eXBlIjtzOjI2OiJtYXN0aGVhZC1iYWNrZ3JvdW5kLXJlcGVhdCI7czoxMToic2VsZWN0LXR5cGUiO3M6Mjg6Im1hc3RoZWFkLWJhY2tncm91bmQtcG9zaXRpb24iO3M6MTE6InNlbGVjdC10eXBlIjtzOjI5OiJtYXN0aGVhZC1ncmFkaWVudC10b3Atb3BhY2l0eSI7czoxMToic2VsZWN0LXR5cGUiO3M6MzI6Im1hc3RoZWFkLWdyYWRpZW50LWJvdHRvbS1vcGFjaXR5IjtzOjExOiJzZWxlY3QtdHlwZSI7czoxNToibWVudS1mb250LWNvbG9yIjtzOjE2OiJjb2xvcnBpY2tlci10eXBlIjtzOjE3OiJtZW51LWFjdGl2ZS1jb2xvciI7czoxNjoiY29sb3JwaWNrZXItdHlwZSI7czoyMzoiaGVhZGVyLWJhY2tncm91bmQtY29sb3IiO3M6MTY6ImNvbG9ycGlja2VyLXR5cGUiO3M6MjM6ImhlYWRlci1iYWNrZ3JvdW5kLWltYWdlIjtzOjE1OiJmaWxldXBsb2FkLXR5cGUiO3M6MjQ6ImhlYWRlci1iYWNrZ3JvdW5kLXJlcGVhdCI7czoxMToic2VsZWN0LXR5cGUiO3M6MjY6ImhlYWRlci1iYWNrZ3JvdW5kLXBvc2l0aW9uIjtzOjExOiJzZWxlY3QtdHlwZSI7czoxNjoiYmFja2dyb3VuZC1jb2xvciI7czoxNjoiY29sb3JwaWNrZXItdHlwZSI7czoxNjoiYmFja2dyb3VuZC1pbWFnZSI7czoxNToiZmlsZXVwbG9hZC10eXBlIjtzOjE3OiJiYWNrZ3JvdW5kLXJlcGVhdCI7czoxMToic2VsZWN0LXR5cGUiO3M6MTk6ImJhY2tncm91bmQtcG9zaXRpb24iO3M6MTE6InNlbGVjdC10eXBlIjtzOjI3OiJmb290ZXItdG9wLWJhY2tncm91bmQtY29sb3IiO3M6MTY6ImNvbG9ycGlja2VyLXR5cGUiO3M6Mjc6ImZvb3Rlci10b3AtYmFja2dyb3VuZC1pbWFnZSI7czoxNToiZmlsZXVwbG9hZC10eXBlIjtzOjI4OiJmb290ZXItdG9wLWJhY2tncm91bmQtcmVwZWF0IjtzOjExOiJzZWxlY3QtdHlwZSI7czozMDoiZm9vdGVyLXRvcC1iYWNrZ3JvdW5kLXBvc2l0aW9uIjtzOjExOiJzZWxlY3QtdHlwZSI7czozMDoiZm9vdGVyLWJvdHRvbS1iYWNrZ3JvdW5kLWNvbG9yIjtzOjE2OiJjb2xvcnBpY2tlci10eXBlIjtzOjMwOiJmb290ZXItYm90dG9tLWJhY2tncm91bmQtaW1hZ2UiO3M6MTU6ImZpbGV1cGxvYWQtdHlwZSI7czozMToiZm9vdGVyLWJvdHRvbS1iYWNrZ3JvdW5kLXJlcGVhdCI7czoxMToic2VsZWN0LXR5cGUiO3M6MzM6ImZvb3Rlci1ib3R0b20tYmFja2dyb3VuZC1wb3NpdGlvbiI7czoxMToic2VsZWN0LXR5cGUiO3M6MjE6ImZvbnQtaGVhZGluZy1zdGFuZGFyZCI7czoxMToic2VsZWN0LXR5cGUiO3M6MTk6ImZvbnQtaGVhZGluZy1nb29nbGUiO3M6MTA6ImlucHV0LXRleHQiO3M6MTg6ImZvbnQtaGVhZGluZy1jb2xvciI7czoxNjoiY29sb3JwaWNrZXItdHlwZSI7czoxODoiZm9udC1ib2R5LXN0YW5kYXJkIjtzOjExOiJzZWxlY3QtdHlwZSI7czoxNjoiZm9udC1ib2R5LWdvb2dsZSI7czoxMDoiaW5wdXQtdGV4dCI7czoxNToiZm9udC1ib2R5LWNvbG9yIjtzOjE2OiJjb2xvcnBpY2tlci10eXBlIjtzOjEzOiJjdXN0b20tc3R5bGVzIjtzOjEzOiJ0ZXh0YXJlYS10eXBlIjtzOjk6ImN1c3RvbS1qcyI7czoxMzoidGV4dGFyZWEtdHlwZSI7fXM6MTA6ImxvZ28taW1hZ2UiO3M6OTU6Imh0dHA6Ly9wYXJhLmxsZWwudXMvdGhlbWVzL3ZlbGx1bS13cC93cC1jb250ZW50L3RoZW1lcy9wYXJhbGxlbHVzLXZlbGx1bS9hc3NldHMvaW1hZ2VzL2xvZ28ucG5nIjtzOjEwOiJsb2dvLXdpZHRoIjtzOjM6IjEzMCI7czo4OiJsb2dvLXVybCI7czowOiIiO3M6MTA6ImxvZ28tdGl0bGUiO3M6NDg6IlZlbGx1bSAtIFRoZSBuZXh0IGdlbmVyYXRpb24gb2YgV29yZFByZXNzIHRoZW1lcyI7czoxNDoiZmF2b3JpdGVzLWljb24iO3M6MzE6Imh0dHA6Ly9wYXJhLmxsZWwudXMvZmF2aWNvbi5pY28iO3M6MTU6Im1vYmlsZS1ib29rbWFyayI7czo0MDoiaHR0cDovL3BhcmEubGxlbC51cy9hcHBsZS10b3VjaC1pY29uLnBuZyI7czoxMjoibGF5b3V0LXN0eWxlIjtzOjE1OiJmdWxsLXdpZHRoLWxlZnQiO3M6NDoic2tpbiI7czoxNjoic3R5bGUtc2tpbi0xLmNzcyI7czoxMjoiZGVzaWduLXdpZHRoIjtzOjA6IiI7czoxNjoiY29udGVudC1wb3NpdGlvbiI7czo2OiJjZW50ZXIiO3M6MTM6Im1hc3RoZWFkLXNpemUiO3M6MTc6InYtbWFzdGhlYWQtbWVkaXVtIjtzOjE0OiJhY2NlbnQtY29sb3ItMSI7czoxOiIjIjtzOjIwOiJpbWFnZS1vdmVybGF5LWVmZmVjdCI7czo1OiJzbGlkZSI7czoxNDoiZG9jay1vbi1zY3JvbGwiO3M6NDoidHJ1ZSI7czoxNjoic2hvdy1icmVhZGNydW1icyI7czo1OiJmYWxzZSI7czoxNjoic21vb3RoLXNjcm9sbGluZyI7czoyMzoiY3VzdG9tLXNjcm9sbGJhcnMtbm8tZmYiO3M6MTA6ImxpbmstY29sb3IiO3M6MToiIyI7czoxNjoibGluay1ob3Zlci1jb2xvciI7czoxOiIjIjtzOjEzOiJlcnJvci1jb250ZW50IjtzOjQ6IjE5NjAiO3M6MjU6Im1hc3RoZWFkLWJhY2tncm91bmQtY29sb3IiO3M6MToiIyI7czoyNToibWFzdGhlYWQtYmFja2dyb3VuZC1pbWFnZSI7czo5NzoiaHR0cDovL3BhcmEubGxlbC51cy90aGVtZXMvdmVsbHVtLXdwL3dwLWNvbnRlbnQvdXBsb2Fkcy8yMDE0LzAyL21hc3RlYWQtdmVydGljYWwtYmctZGVmYXVsdC0yLmpwZyI7czoyNjoibWFzdGhlYWQtYmFja2dyb3VuZC1yZXBlYXQiO3M6NToiY292ZXIiO3M6Mjg6Im1hc3RoZWFkLWJhY2tncm91bmQtcG9zaXRpb24iO3M6NDoibGVmdCI7czoyOToibWFzdGhlYWQtZ3JhZGllbnQtdG9wLW9wYWNpdHkiO3M6MjoiLjMiO3M6MzI6Im1hc3RoZWFkLWdyYWRpZW50LWJvdHRvbS1vcGFjaXR5IjtzOjI6Ii42IjtzOjE1OiJtZW51LWZvbnQtY29sb3IiO3M6MToiIyI7czoxNzoibWVudS1hY3RpdmUtY29sb3IiO3M6MToiIyI7czoyMzoiaGVhZGVyLWJhY2tncm91bmQtY29sb3IiO3M6MToiIyI7czoyMzoiaGVhZGVyLWJhY2tncm91bmQtaW1hZ2UiO3M6MDoiIjtzOjI0OiJoZWFkZXItYmFja2dyb3VuZC1yZXBlYXQiO3M6OToibm8tcmVwZWF0IjtzOjI2OiJoZWFkZXItYmFja2dyb3VuZC1wb3NpdGlvbiI7czo0OiJsZWZ0IjtzOjE2OiJiYWNrZ3JvdW5kLWNvbG9yIjtzOjE6IiMiO3M6MTY6ImJhY2tncm91bmQtaW1hZ2UiO3M6MDoiIjtzOjE3OiJiYWNrZ3JvdW5kLXJlcGVhdCI7czo5OiJuby1yZXBlYXQiO3M6MTk6ImJhY2tncm91bmQtcG9zaXRpb24iO3M6NToiY292ZXIiO3M6Mjc6ImZvb3Rlci10b3AtYmFja2dyb3VuZC1jb2xvciI7czoxOiIjIjtzOjI3OiJmb290ZXItdG9wLWJhY2tncm91bmQtaW1hZ2UiO3M6MDoiIjtzOjI4OiJmb290ZXItdG9wLWJhY2tncm91bmQtcmVwZWF0IjtzOjk6Im5vLXJlcGVhdCI7czozMDoiZm9vdGVyLXRvcC1iYWNrZ3JvdW5kLXBvc2l0aW9uIjtzOjQ6ImxlZnQiO3M6MzA6ImZvb3Rlci1ib3R0b20tYmFja2dyb3VuZC1jb2xvciI7czoxOiIjIjtzOjMwOiJmb290ZXItYm90dG9tLWJhY2tncm91bmQtaW1hZ2UiO3M6MDoiIjtzOjMxOiJmb290ZXItYm90dG9tLWJhY2tncm91bmQtcmVwZWF0IjtzOjk6Im5vLXJlcGVhdCI7czozMzoiZm9vdGVyLWJvdHRvbS1iYWNrZ3JvdW5kLXBvc2l0aW9uIjtzOjQ6ImxlZnQiO3M6MjE6ImZvbnQtaGVhZGluZy1zdGFuZGFyZCI7czo3OiJkZWZhdWx0IjtzOjE5OiJmb250LWhlYWRpbmctZ29vZ2xlIjtzOjA6IiI7czoxODoiZm9udC1oZWFkaW5nLWNvbG9yIjtzOjE6IiMiO3M6MTg6ImZvbnQtYm9keS1zdGFuZGFyZCI7czo3OiJkZWZhdWx0IjtzOjE2OiJmb250LWJvZHktZ29vZ2xlIjtzOjA6IiI7czoxNToiZm9udC1ib2R5LWNvbG9yIjtzOjE6IiMiO3M6MTM6ImN1c3RvbS1zdHlsZXMiO3M6NzcxOiJAbWVkaWEgc2NyZWVuIGFuZCAobWluLXdpZHRoOiA3NjhweCkgew0KICAgIC8qIEN1c3RvbSBNZWdhIE1lbnUgQmFja2dyb3VuZHMgKi8NCiAgICAubW0tcGFnZXMtY3VzdG9tLWJnIHVsLnN1Yi1tZW51LTEgeyBwYWRkaW5nOiAwcHggNjVweCA4NXB4IDBweCAhaW1wb3J0YW50OyB3aWR0aDogNTQwcHggIWltcG9ydGFudDsgYmFja2dyb3VuZC1pbWFnZTogdXJsKFwmIzAzOTtodHRwOi8vcGFyYS5sbGVsLnVzL3RoZW1lcy92ZWxsdW0td3Avd3AtY29udGVudC91cGxvYWRzLzIwMTQvMDIvbWVnYW1lbnUtZmVhdHVyZXMtYmcucG5nXCYjMDM5OykgIWltcG9ydGFudDsgYmFja2dyb3VuZC1yZXBlYXQ6IG5vLXJlcGVhdCAhaW1wb3J0YW50OyBiYWNrZ3JvdW5kLXBvc2l0aW9uOiAxMDAlIDEwMCUgIWltcG9ydGFudDsgfQ0KICAgIC5zdHlsZS1za2luLTIgLm1tLXBhZ2VzLWN1c3RvbS1iZyB1bC5zdWItbWVudS0xLA0KICAgIC5zdHlsZS1za2luLTUgLm1tLXBhZ2VzLWN1c3RvbS1iZyB1bC5zdWItbWVudS0xLA0KICAgIC5zdHlsZS1za2luLTYgLm1tLXBhZ2VzLWN1c3RvbS1iZyB1bC5zdWItbWVudS0xLA0KICAgIC5zdHlsZS1za2luLTcgLm1tLXBhZ2VzLWN1c3RvbS1iZyB1bC5zdWItbWVudS0xIHsgYmFja2dyb3VuZC1pbWFnZTogdXJsKFwmIzAzOTtodHRwOi8vcGFyYS5sbGVsLnVzL3RoZW1lcy92ZWxsdW0td3Avd3AtY29udGVudC91cGxvYWRzLzIwMTQvMDIvbWVnYW1lbnUtZmVhdHVyZXMtYmctYWx0LnBuZ1wmIzAzOTspICFpbXBvcnRhbnQ7IH0NCn0iO3M6OToiY3VzdG9tLWpzIjtzOjA6IiI7czo1OiJpbmRleCI7czoxOToidmVsbHVtX29wdGlvbnMtcGFnZSI7czoxMjoiYW5jZXN0b3Jfa2V5IjtzOjA6IiI7czoxMToidmVyc2lvbl9rZXkiO3M6MjA6ImlkX3l1Z2dlNGt5aGQwaTJ0NzZzIjtzOjEwOiJpbXBvcnRfa2V5IjtzOjU6IkFycmF5Ijt9',

			'blog-options' => 
				'YTozMjp7czoxMToiZmllbGRfdHlwZXMiO2E6Mjc6e3M6MTM6ImJsb2ctdGVtcGxhdGUiO3M6MTE6InNlbGVjdC10eXBlIjtzOjE3OiJibG9nLWdyaWQtY29sdW1ucyI7czoxMDoiaW5wdXQtdGV4dCI7czoxMzoicG9zdC1leGNlcnB0cyI7czoxODoiY2hlY2tib3gtYm9vbC10eXBlIjtzOjE0OiJleGNlcnB0LWxlbmd0aCI7czoxMDoiaW5wdXQtdGV4dCI7czo5OiJyZWFkLW1vcmUiO3M6MTA6ImlucHV0LXRleHQiO3M6MTE6ImltYWdlLXdpZHRoIjtzOjEwOiJpbnB1dC10ZXh0IjtzOjEyOiJpbWFnZS1oZWlnaHQiO3M6MTA6ImlucHV0LXRleHQiO3M6MTY6InNob3ctcG9zdC1mb3JtYXQiO3M6MTg6ImNoZWNrYm94LWJvb2wtdHlwZSI7czo5OiJzaG93LWRhdGUiO3M6MTg6ImNoZWNrYm94LWJvb2wtdHlwZSI7czoxNToic2hvdy1jYXRlZ29yaWVzIjtzOjE4OiJjaGVja2JveC1ib29sLXR5cGUiO3M6MTg6InNob3ctY29tbWVudC1jb3VudCI7czoxODoiY2hlY2tib3gtYm9vbC10eXBlIjtzOjk6InNob3ctdGFncyI7czoxODoiY2hlY2tib3gtYm9vbC10eXBlIjtzOjE3OiJzaW5nbGUtcG9zdC1pbWFnZSI7czoxODoiY2hlY2tib3gtYm9vbC10eXBlIjtzOjE4OiJzaW5nbGUtaW1hZ2Utd2lkdGgiO3M6MTA6ImlucHV0LXRleHQiO3M6MTk6InNpbmdsZS1pbWFnZS1oZWlnaHQiO3M6MTA6ImlucHV0LXRleHQiO3M6MjM6InNpbmdsZS1zaG93LXBvc3QtZm9ybWF0IjtzOjE4OiJjaGVja2JveC1ib29sLXR5cGUiO3M6MTY6InNpbmdsZS1zaG93LWRhdGUiO3M6MTg6ImNoZWNrYm94LWJvb2wtdHlwZSI7czoyMjoic2luZ2xlLXNob3ctY2F0ZWdvcmllcyI7czoxODoiY2hlY2tib3gtYm9vbC10eXBlIjtzOjI0OiJzaW5nbGUtc2hvdy1jb21tZW50LWxpbmsiO3M6MTg6ImNoZWNrYm94LWJvb2wtdHlwZSI7czoyMDoic2hvdy1wb3N0LW5hdmlnYXRpb24iO3M6MTg6ImNoZWNrYm94LWJvb2wtdHlwZSI7czoxNzoiYXVkaW9fZm9ybWF0X3RleHQiO3M6MTA6ImlucHV0LXRleHQiO3M6MTk6ImdhbGxlcnlfZm9ybWF0X3RleHQiO3M6MTA6ImlucHV0LXRleHQiO3M6MTc6ImltYWdlX2Zvcm1hdF90ZXh0IjtzOjEwOiJpbnB1dC10ZXh0IjtzOjE2OiJsaW5rX2Zvcm1hdF90ZXh0IjtzOjEwOiJpbnB1dC10ZXh0IjtzOjE3OiJxdW90ZV9mb3JtYXRfdGV4dCI7czoxMDoiaW5wdXQtdGV4dCI7czoxNzoidmlkZW9fZm9ybWF0X3RleHQiO3M6MTA6ImlucHV0LXRleHQiO3M6MTk6ImdlbmVyYWxfZm9ybWF0X3RleHQiO3M6MTA6ImlucHV0LXRleHQiO31zOjEzOiJibG9nLXRlbXBsYXRlIjtzOjE1OiJibG9nLWltYWdlLWxlZnQiO3M6MTc6ImJsb2ctZ3JpZC1jb2x1bW5zIjtzOjE6IjMiO3M6MTM6InBvc3QtZXhjZXJwdHMiO3M6NDoidHJ1ZSI7czoxNDoiZXhjZXJwdC1sZW5ndGgiO3M6MjoiNTAiO3M6OToicmVhZC1tb3JlIjtzOjk6InJlYWQgbW9yZSI7czoxMToiaW1hZ2Utd2lkdGgiO3M6MzoiNjMwIjtzOjEyOiJpbWFnZS1oZWlnaHQiO3M6MzoiNDUwIjtzOjE2OiJzaG93LXBvc3QtZm9ybWF0IjtzOjQ6InRydWUiO3M6OToic2hvdy1kYXRlIjtzOjU6ImZhbHNlIjtzOjE1OiJzaG93LWNhdGVnb3JpZXMiO3M6NToiZmFsc2UiO3M6MTg6InNob3ctY29tbWVudC1jb3VudCI7czo0OiJ0cnVlIjtzOjk6InNob3ctdGFncyI7czo1OiJmYWxzZSI7czoxNzoic2luZ2xlLXBvc3QtaW1hZ2UiO3M6NDoidHJ1ZSI7czoxODoic2luZ2xlLWltYWdlLXdpZHRoIjtzOjA6IiI7czoxOToic2luZ2xlLWltYWdlLWhlaWdodCI7czowOiIiO3M6MjM6InNpbmdsZS1zaG93LXBvc3QtZm9ybWF0IjtzOjQ6InRydWUiO3M6MTY6InNpbmdsZS1zaG93LWRhdGUiO3M6NToiZmFsc2UiO3M6MjI6InNpbmdsZS1zaG93LWNhdGVnb3JpZXMiO3M6NToiZmFsc2UiO3M6MjQ6InNpbmdsZS1zaG93LWNvbW1lbnQtbGluayI7czo0OiJ0cnVlIjtzOjIwOiJzaG93LXBvc3QtbmF2aWdhdGlvbiI7czo0OiJ0cnVlIjtzOjE3OiJhdWRpb19mb3JtYXRfdGV4dCI7czowOiIiO3M6MTk6ImdhbGxlcnlfZm9ybWF0X3RleHQiO3M6MDoiIjtzOjE3OiJpbWFnZV9mb3JtYXRfdGV4dCI7czowOiIiO3M6MTY6ImxpbmtfZm9ybWF0X3RleHQiO3M6MDoiIjtzOjE3OiJxdW90ZV9mb3JtYXRfdGV4dCI7czowOiIiO3M6MTc6InZpZGVvX2Zvcm1hdF90ZXh0IjtzOjA6IiI7czoxOToiZ2VuZXJhbF9mb3JtYXRfdGV4dCI7czowOiIiO3M6NToiaW5kZXgiO3M6MTk6InZlbGx1bV9ibG9nLW9wdGlvbnMiO3M6MTI6ImFuY2VzdG9yX2tleSI7czowOiIiO3M6MTE6InZlcnNpb25fa2V5IjtzOjIwOiJpZF9teXdscTMyN3pibzM1OHI2cyI7czoxMDoiaW1wb3J0X2tleSI7czo1OiJBcnJheSI7fSAgICAvKiBDdXN0b20gTWVnYSBNZW51IEJhY2tncm91bmRzICovDQogICAgLm1tLXBhZ2VzLWN1c3RvbS1iZyB1bC5zdWItbWVudS0xIHsgcGFkZGluZzogMHB4IDY1cHggODVweCAwcHggIWltcG9ydGFudDsgd2lkdGg6IDU0MHB4ICFpbXBvcnRhbnQ7IGJhY2tncm91bmQtaW1hZ2U6IHVybChcJiMwMzk7aHR0cDovL3BhcmEubGxlbC51cy90aGVtZXMvdmVsbHVtLXdwL3dwLWNvbnRlbnQvdXBsb2Fkcy8yMDE0LzAyL21lZ2FtZW51LWZlYXR1cmVzLWJnLnBuZ1wmIzAzOTspICFpbXBvcnRhbnQ7IGJhY2tncm91bmQtcmVwZWF0OiBuby1yZXBlYXQgIWltcG9ydGFudDsgYmFja2dyb3VuZC1wb3NpdGlvbjogMTAwJSAxMDAlICFpbXBvcnRhbnQ7IH0NCiAgICAuc3R5bGUtc2tpbi0yIC5tbS1wYWdlcy1jdXN0b20tYmcgdWwuc3ViLW1lbnUtMSwNCiAgICAuc3R5bGUtc2tpbi01IC5tbS1wYWdlcy1jdXN0b20tYmcgdWwuc3ViLW1lbnUtMSwNCiAgICAuc3R5bGUtc2tpbi02IC5tbS1wYWdlcy1jdXN0b20tYmcgdWwuc3ViLW1lbnUtMSwNCiAgICAuc3R5bGUtc2tpbi03IC5tbS1wYWdlcy1jdXN0b20tYmcgdWwuc3ViLW1lbnUtMSB7IGJhY2tncm91bmQtaW1hZ2U6IHVybChcJiMwMzk7aHR0cDovL3BhcmEubGxlbC51cy90aGVtZXMvdmVsbHVtLXdwL3dwLWNvbnRlbnQvdXBsb2Fkcy8yMDE0LzAyL21lZ2FtZW51LWZlYXR1cmVzLWJnLWFsdC5wbmdcJiMwMzk7KSAhaW1wb3J0YW50OyB9DQp9IjtzOjk6ImN1c3RvbS1qcyI7czowOiIiO3M6NToiaW5kZXgiO3M6MTk6InZlbGx1bV9vcHRpb25zLXBhZ2UiO3M6MTI6ImFuY2VzdG9yX2tleSI7czowOiIiO3M6MTE6InZlcnNpb25fa2V5IjtzOjIwOiJpZF95dWdnZTRreWhkMGkydDc2cyI7czoxMDoiaW1wb3J0X2tleSI7czo1OiJBcnJheSI7fQ==',

			'sidebar_settings' => 
				'YToxOntzOjEzOiJzaWRlYmFyc19saXN0IjthOjk6e3M6OToiaG9tZS1wYWdlIjthOjM6e3M6NToidGl0bGUiO3M6OToiSG9tZSBQYWdlIjtzOjU6ImFsaWFzIjtzOjk6ImhvbWUtcGFnZSI7czoxMToiZGVzY3JpcHRpb24iO3M6MzU6IkEgc2lkZWJhciBmb3IgdGhlIGhvbWUgcGFnZSBsYXlvdXQuIjt9czo0OiJibG9nIjthOjM6e3M6NToidGl0bGUiO3M6NDoiQmxvZyI7czo1OiJhbGlhcyI7czo0OiJibG9nIjtzOjExOiJkZXNjcmlwdGlvbiI7czozNToiVGhlIGRlZmF1bHQgc2lkZWJhciBmb3IgYmxvZyBwYWdlcy4iO31zOjExOiJzaW5nbGUtcG9zdCI7YTozOntzOjU6InRpdGxlIjtzOjE4OiJCbG9nIC0gU2luZ2xlIFBvc3QiO3M6NToiYWxpYXMiO3M6MTE6InNpbmdsZS1wb3N0IjtzOjExOiJkZXNjcmlwdGlvbiI7czozMjoiQSBzaWRlYmFyIGZvciBzaW5nbGUgYmxvZyBwb3N0cy4iO31zOjQ6InBhZ2UiO2E6Mzp7czo1OiJ0aXRsZSI7czo0OiJQYWdlIjtzOjU6ImFsaWFzIjtzOjQ6InBhZ2UiO3M6MTE6ImRlc2NyaXB0aW9uIjtzOjMwOiJUaGUgZGVmYXVsdCBzaWRlYmFyIGZvciBwYWdlcy4iO31zOjk6InBvcnRmb2xpbyI7YTozOntzOjU6InRpdGxlIjtzOjk6IlBvcnRmb2xpbyI7czo1OiJhbGlhcyI7czo5OiJwb3J0Zm9saW8iO3M6MTE6ImRlc2NyaXB0aW9uIjtzOjMwOiJBIHNpZGViYXIgZm9yIHBvcnRmb2xpbyBhcmVhcy4iO31zOjE2OiJibG9nLWFsdGVybmF0ZS0xIjthOjM6e3M6NToidGl0bGUiO3M6MTg6IkJsb2cgKGFsdGVybmF0ZSAxKSI7czo1OiJhbGlhcyI7czoxNjoiYmxvZy1hbHRlcm5hdGUtMSI7czoxMToiZGVzY3JpcHRpb24iO3M6NTE6IkFuIGFsdGVybmF0aXZlIHNpZGViYXIgdG8gdGhlIGRlZmF1bHQgYmxvZyBzaWRlYmFyLiI7fXM6MTY6ImJsb2ctYWx0ZXJuYXRlLTIiO2E6Mzp7czo1OiJ0aXRsZSI7czoxODoiQmxvZyAoYWx0ZXJuYXRlIDIpIjtzOjU6ImFsaWFzIjtzOjE2OiJibG9nLWFsdGVybmF0ZS0yIjtzOjExOiJkZXNjcmlwdGlvbiI7czo0ODoiQW5vdGhlciBhbHRlcm5hdGl2ZSBibG9nIHNpZGViYXIgdG8gdGhlIGRlZmF1bHQuIjt9czo0OiJzaG9wIjthOjM6e3M6NToidGl0bGUiO3M6NDoiU2hvcCI7czo1OiJhbGlhcyI7czo0OiJzaG9wIjtzOjExOiJkZXNjcmlwdGlvbiI7czozMToiQSBzaWRlYmFyIGZvciB0aGUgc2hvcCBsYXlvdXRzLiI7fXM6NToiZm9ydW0iO2E6Mzp7czo1OiJ0aXRsZSI7czo1OiJGb3J1bSI7czo1OiJhbGlhcyI7czo1OiJmb3J1bSI7czoxMToiZGVzY3JpcHRpb24iO3M6MTQ6IkZvcnVtcyBTaWRlYmFyIjt9fX0='
			*/
		);

		// Loop through data and add to DB as needed
		// --------------------------------------------------
		foreach ($demo_data as $option_key => $option_data) {
			
			// Generate the 'option_name' for the row
			$option_name = $shortname . $option_key;

			// Update database if row doesn't exist
			if( !get_option( $option_name ) ) {
				update_option( $option_name, maybe_unserialize(base64_decode($option_data, true)) );
			}
		}



		# --------------------------------------------------
		# Extensions/Plugin Options
		# --------------------------------------------------
		
		// Row => Data  (doesn't include $shortname prefix)
		$options_data = array(

			// UberMenu
			'wp-mega-menu-settings' => 
				'a:28:{s:16:"current-panel-id";s:12:"basic-config";s:18:"wpmega-orientation";s:8:"vertical";s:23:"megaMenu-responsiveness";s:0:"";s:15:"responsive-menu";s:2:"on";s:22:"responsive-menu-toggle";s:2:"on";s:27:"responsive-menu-toggle-text";s:1:" ";s:16:"iOS-close-button";s:3:"off";s:23:"wpmega-animation-header";s:0:"";s:13:"wpmega-jquery";s:2:"on";s:17:"wpmega-transition";s:4:"fade";s:21:"wpmega-animation-time";s:3:"300";s:14:"wpmega-trigger";s:11:"hoverIntent";s:21:"wpmega-hover-interval";s:2:"20";s:20:"wpmega-hover-timeout";s:3:"400";s:19:"wpmega-submenu-full";s:3:"off";s:22:"mobile-settings-header";s:0:"";s:13:"android-click";s:2:"on";s:20:"basic-other-settings";s:0:"";s:18:"reposition-on-load";s:2:"on";s:18:"wpmega-desc-header";s:0:"";s:19:"wpmega-descriptions";s:0:"";s:20:"wpmega-description-0";s:3:"off";s:20:"wpmega-description-1";s:3:"off";s:20:"wpmega-description-2";s:3:"off";s:21:"wpmega-style-settings";s:0:"";s:12:"wpmega-style";s:6:"preset";s:19:"wpmega-style-preset";s:20:"theme-default-styles";s:20:"ubermenu-pro-upgrade";s:0:"";}',

			// Visual Composer
			'wpb_js_content_types' => 
				'a:4:{i:0;s:4:"post";i:1;s:4:"page";i:2;s:9:"portfolio";i:3;s:12:"static_block";}'
		);


		// Loop through data and add to DB as needed
		// --------------------------------------------------
		foreach ($options_data as $option_key => $option_data) {
			
			// Generate the 'option_name' for the row
			$option_name = $option_key;

			// Update database if row doesn't exist
			if( !get_option( $option_name ) ) {
				update_option( $option_name, maybe_unserialize( $option_data, true ) );
			}
		}

	}

endif; 

# --------------------------------------------------
# Add action for data import
# --------------------------------------------------

// Call the demo data function after theme setup (admin only)
add_action( 'after_setup_theme', 'theme_demo_data' );




# --------------------------------------------------
# Import demo slide show
# --------------------------------------------------

function importDemoSlider() {
	global $wpdb, $shortname;

	// Make sure the DB tables exist
	// --------------------------------------------------
	require_once( ABSPATH . 'wp-admin/includes/upgrade.php' );

	$RevSlider_sql = "CREATE TABLE ". $wpdb->prefix ."revslider_sliders (
				  id int(9) NOT NULL AUTO_INCREMENT,
				  title tinytext NOT NULL,
				  alias tinytext,
				  params text NOT NULL,
				  PRIMARY KEY (id)
				)$charset_collate;";
	dbDelta($RevSlider_sql);

	$Slides_sql = "CREATE TABLE ". $wpdb->prefix ."revslider_slides (
				  id int(9) NOT NULL AUTO_INCREMENT,
				  slider_id int(9) NOT NULL,
				  slide_order int not NULL,		  
				  params text NOT NULL,
				  layers text NOT NULL,
				  PRIMARY KEY (id)
				)$charset_collate;";
	dbDelta($Slides_sql);


	// ==================================================
	// Add default Slide Show
	// ==================================================
	$rev_slider = array();
	$rev_slider["title"]  = 'Home Page';
	$rev_slider["alias"]  = 'home-page';
	$rev_slider["params"] = '{"title":"Home Page","alias":"home-page","shortcode":"[rev_slider home-page]","source_type":"gallery","post_types":"post","post_category":"category_3","post_sortby":"ID","posts_sort_direction":"DESC","max_slider_posts":"30","excerpt_limit":"55","slider_template_id":"","posts_list":"","slider_type":"fullscreen","fullscreen_offset_container":"","full_screen_align_force":"on","auto_height":"on","force_full_width":"off","responsitive_w1":"940","responsitive_sw1":"770","responsitive_w2":"780","responsitive_sw2":"500","responsitive_w3":"510","responsitive_sw3":"310","responsitive_w4":"0","responsitive_sw4":"0","responsitive_w5":"0","responsitive_sw5":"0","responsitive_w6":"0","responsitive_sw6":"0","width":"1300","height":"900","delay":"6000","shuffle":"off","lazy_load":"off","use_wpml":"off","stop_slider":"on","stop_after_loops":0,"stop_at_slide":2,"load_googlefont":"false","google_font":["PT+Sans+Narrow:400,700"],"position":"center","margin_top":0,"margin_bottom":0,"margin_left":0,"margin_right":0,"shadow_type":"0","show_timerbar":"hide","padding":0,"background_color":"#393939","show_background_image":"false","background_image":"","bg_fit":"cover","bg_repeat":"no-repeat","bg_position":"center top","touchenabled":"off","stop_on_hover":"off","navigaion_type":"none","navigation_arrows":"none","navigation_style":"round","navigaion_always_on":"false","hide_thumbs":200,"navigaion_align_hor":"center","navigaion_align_vert":"bottom","navigaion_offset_hor":"0","navigaion_offset_vert":30,"leftarrow_align_hor":"left","leftarrow_align_vert":"center","leftarrow_offset_hor":0,"leftarrow_offset_vert":0,"rightarrow_align_hor":"right","rightarrow_align_vert":"center","rightarrow_offset_hor":0,"rightarrow_offset_vert":0,"thumb_width":100,"thumb_height":50,"thumb_amount":5,"hide_slider_under":0,"hide_defined_layers_under":0,"hide_all_layers_under":0,"hide_arrows_on_mobile":"on","hide_thumbs_under_resolution":0,"start_with_slide":"1","first_transition_type":"fade","first_transition_duration":300,"first_transition_slot_amount":7,"jquery_noconflict":"on","js_to_body":"false","output_type":"none","template":"false","0":["PT+Sans+Narrow:400,700"]}';
	
	if( !get_option( $shortname.$rev_slider["alias"] ) && !get_option( "slider_".$rev_slider["alias"] ) ) {

		$slider_rows = $wpdb->insert( $wpdb->prefix.'revslider_sliders', 
			array(
				'title' => $rev_slider["title"],
				'alias' => $rev_slider["alias"],
				'params' => $rev_slider["params"]
			)
		);


		if ($slider_rows) {

			// Get the new ID
			$sql = 'SELECT id FROM '. $wpdb->prefix .'revslider_sliders WHERE alias = "'. $rev_slider["alias"] .'" ;';
			$newSlider = $wpdb->get_results($sql);
			$sliderID = $newSlider[0]->id;


			// Add default Slides to Slide Show
			// --------------------------------------------------
			if ($sliderID) {

				$slides = array();

				// Slide 1
				$slides[] = array(
					'params' => 
						'{"background_type":"image","title":"Slide 1","state":"published","date_from":"","date_to":"","slide_transition":"fade","0":"Choose Image","slot_amount":7,"transition_rotation":0,"transition_duration":300,"delay":1600,"enable_link":"false","link_type":"regular","link":"","link_open_in":"same","slide_link":"nothing","link_pos":"front","slide_thumb":"","image_id":"2787","slide_bg_color":"#E7E7E7","slide_bg_external":"","bg_fit":"cover","bg_fit_x":"100","bg_fit_y":"100","bg_repeat":"no-repeat","bg_position":"center center","bg_position_x":"0","bg_position_y":"0","image":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2013\/12\/ss-home-1-desktop-bg.jpg","0":"Choose Image","kenburn_effect":"off","kb_start_fit":"100","kb_end_fit":"100","bg_end_position":"center top","kb_duration":"6000","kb_easing":"Linear.easeNone"}',
					
					'layers' => 
						'[]'
				);

				// Slide 2
				$slides[] = array(
					'params' => 
						'{"background_type":"image","title":"Slide 1 - with graphics","state":"published","date_from":"","date_to":"","slide_transition":"fade","0":"Choose Image","slot_amount":7,"transition_rotation":0,"transition_duration":600,"delay":5000,"enable_link":"false","link_type":"regular","link":"","link_open_in":"same","slide_link":"nothing","link_pos":"front","slide_thumb":"","image_id":"4571","slide_bg_color":"#E7E7E7","slide_bg_external":"","bg_fit":"cover","bg_fit_x":"100","bg_fit_y":"100","bg_repeat":"no-repeat","bg_position":"center center","bg_position_x":"0","bg_position_y":"0","image":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/ss-home-1-desktop-blur-only-bg.jpg","kenburn_effect":"off","kb_start_fit":"100","kb_end_fit":"100","bg_end_position":"center top","kb_duration":"6000","kb_easing":"Linear.easeNone","0":"Choose Image"}',
					
					'layers' => 
						'[{"style":"","text":"Vellum - WordPress Theme","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/ss-home-1-logo.png","left":-12,"top":-100,"animation":"tp-fade","easing":"Power3.easeInOut","speed":800,"align_hor":"center","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":600,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":638,"height":190,"serial":"0","endTimeFinal":4200,"endSpeedFinal":300,"realEndTime":5000,"timeLast":4400,"alt":"Vellum - WordPress Theme","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"hidden-phone","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""},{"style":"","text":"Find Your Inspiration. Theme Features.","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2013\/12\/ss-home-1-features-button-alt.png","left":110,"top":120,"animation":"sfr","easing":"Power4.easeInOut","speed":750,"align_hor":"right","align_vert":"middle","hiddenunder":true,"resizeme":true,"link":"\/themes\/vellum-dev\/features\/","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":1050,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":305,"height":285,"serial":"1","endTimeFinal":4250,"endSpeedFinal":300,"realEndTime":5000,"timeLast":2950,"alt":"Find Your Inspiration. Theme Features.","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"hidden-phone","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""},{"style":"","text":"More","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2013\/12\/ss-home-1-down-arrow.png","left":0,"top":90,"animation":"sft","easing":"Power4.easeInOut","speed":500,"align_hor":"center","align_vert":"bottom","hiddenunder":false,"resizeme":true,"link":"#AfterSlider","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":2050,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":63,"height":63,"serial":"2","endTimeFinal":4500,"endSpeedFinal":300,"realEndTime":5000,"timeLast":2950,"alt":"More","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"visible-desktop","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""},{"style":"","text":"Vellum - WordPress Theme","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/ss-home-1-logo.png","left":-10,"top":-75,"animation":"tp-fade","easing":"Power3.easeInOut","speed":800,"align_hor":"center","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":600,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":1007,"height":300,"serial":"3","endTimeFinal":4200,"endSpeedFinal":300,"realEndTime":5000,"timeLast":4400,"alt":"Vellum - WordPress Theme","scaleX":"1007","scaleY":"300","scaleProportional":true,"attrID":"","attrClasses":"visible-phone","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""}]'
				);

				// Loop through data and add to DB 
				// --------------------------------------------------
				$slide_order = 1;
				foreach ($slides as $slide) {
					$rows_affected = $wpdb->insert( $wpdb->prefix.'revslider_slides', 
						array(
							'slider_id' => $sliderID,
							'slide_order' => $slide_order,
							'params' => $slide['params'],
							'layers' => $slide['layers']
						)
					);
					$slide_order++;
				}

			}
										

			// Mark the database showing this has been done
			// --------------------------------------------------
			$rev_slider['slides'] = $slides;
			update_option( "slider_".$rev_slider["alias"], $rev_slider );

		} // if $slider_rows (slide show added)
	
	} // if !get_option( [theme]_[slider-alias] ) && !get_option( "slider_[slider-alias] )


	#================================================================================================================


	// ==================================================
	// Add Another Slide Show
	// ==================================================
	$rev_slider = array();
	$rev_slider["title"]  = 'Home - Full Screen with Video';
	$rev_slider["alias"]  = 'home-full-screen-with-video';
	$rev_slider["params"] = '{"title":"Home - Full Screen with Video","alias":"home-full-screen-with-video","shortcode":"[rev_slider home-full-screen-with-video]","source_type":"gallery","post_types":"post","post_category":"category_3","post_sortby":"ID","posts_sort_direction":"DESC","max_slider_posts":"30","excerpt_limit":"55","slider_template_id":"","posts_list":"","slider_type":"fullscreen","fullscreen_offset_container":"","full_screen_align_force":"on","auto_height":"on","force_full_width":"off","responsitive_w1":"940","responsitive_sw1":"770","responsitive_w2":"780","responsitive_sw2":"500","responsitive_w3":"510","responsitive_sw3":"310","responsitive_w4":"0","responsitive_sw4":"0","responsitive_w5":"0","responsitive_sw5":"0","responsitive_w6":"0","responsitive_sw6":"0","width":"1300","height":"900","delay":"6000","shuffle":"off","lazy_load":"off","use_wpml":"off","stop_slider":"on","stop_after_loops":0,"stop_at_slide":2,"load_googlefont":"false","google_font":["PT+Sans+Narrow:400,700"],"position":"center","margin_top":0,"margin_bottom":0,"margin_left":0,"margin_right":0,"shadow_type":"0","show_timerbar":"hide","padding":0,"background_color":"#393939","show_background_image":"false","background_image":"","bg_fit":"cover","bg_repeat":"no-repeat","bg_position":"center top","touchenabled":"on","stop_on_hover":"off","navigaion_type":"none","navigation_arrows":"none","navigation_style":"round","navigaion_always_on":"false","hide_thumbs":200,"navigaion_align_hor":"center","navigaion_align_vert":"bottom","navigaion_offset_hor":"0","navigaion_offset_vert":30,"leftarrow_align_hor":"left","leftarrow_align_vert":"center","leftarrow_offset_hor":0,"leftarrow_offset_vert":0,"rightarrow_align_hor":"right","rightarrow_align_vert":"center","rightarrow_offset_hor":0,"rightarrow_offset_vert":0,"thumb_width":100,"thumb_height":50,"thumb_amount":5,"hide_slider_under":0,"hide_defined_layers_under":768,"hide_all_layers_under":0,"hide_arrows_on_mobile":"on","hide_bullets_on_mobile":"off","hide_thumbs_on_mobile":"off","hide_thumbs_under_resolution":0,"start_with_slide":"1","first_transition_type":"fade","first_transition_duration":300,"first_transition_slot_amount":7,"jquery_noconflict":"on","js_to_body":"false","output_type":"none","template":"false","0":["PT+Sans+Narrow:400,700"]}';
	
	
	if( !get_option( $shortname.$rev_slider["alias"] ) && !get_option( "slider_".$rev_slider["alias"] ) ) {

		$slider_rows = $wpdb->insert( $wpdb->prefix.'revslider_sliders', 
			array(
				'title' => $rev_slider["title"],
				'alias' => $rev_slider["alias"],
				'params' => $rev_slider["params"]
			)
		);


		if ($slider_rows) {

			// Get the new ID
			$sql = 'SELECT id FROM '. $wpdb->prefix .'revslider_sliders WHERE alias = "'. $rev_slider["alias"] .'" ;';
			$newSlider = $wpdb->get_results($sql);
			$sliderID = $newSlider[0]->id;


			// Add default Slides to Slide Show
			// --------------------------------------------------
			if ($sliderID) {

				$slides = array();

				// Slide 1
				$slides[] = array(
					'params' => 
						'{"background_type":"image","title":"Video","state":"published","date_from":"","date_to":"","slide_transition":"fade","0":"Choose Image","slot_amount":7,"transition_rotation":0,"transition_duration":100,"delay":1000,"enable_link":"false","link_type":"regular","link":"","link_open_in":"same","slide_link":"nothing","link_pos":"front","slide_thumb":"","image_id":"2787","slide_bg_color":"#E7E7E7","slide_bg_external":"","bg_fit":"cover","bg_fit_x":"100","bg_fit_y":"100","bg_repeat":"no-repeat","bg_position":"center center","bg_position_x":"0","bg_position_y":"0","image":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2013\/12\/ss-home-1-desktop-bg.jpg","kenburn_effect":"off","kb_start_fit":"100","kb_end_fit":"100","bg_end_position":"center top","kb_duration":"6000","kb_easing":"Linear.easeNone","0":"Choose Image"}',
					
					'layers' => 
						'[{"type":"video","style":"","video_type":"html5","video_width":1300,"video_height":900,"video_data":{"video_type":"html5","urlPoster":"","urlMp4":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2013\/12\/vellum-intro.mp4","urlWebm":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2013\/12\/vellum-intro.webm","urlOgv":"","width":"1280","height":"720","args":"","previewimage":"","autoplay":true,"autoplayonlyfirsttime":false,"nextslide":true,"forcerewind":false,"fullwidth":true,"videoloop":false,"controls":true,"mute":false,"cover":false,"dotted":"none","ratio":"16:9","id":""},"text":"Html5 Video","video_title":"Html5 Video","video_image_url":"","left":0,"top":0,"align_hor":"left","align_vert":"top","animation":"tp-fade","easing":"Power3.easeInOut","speed":2000,"hiddenunder":true,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":50,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":-1,"height":-1,"serial":"0","endTimeFinal":-1000,"endSpeedFinal":300,"realEndTime":1000,"timeLast":950,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""}]'
				);

				// Slide 2
				$slides[] = array(
					'params' => 
						'{"background_type":"image","title":"Start Image","state":"published","date_from":"","date_to":"","slide_transition":"fade","0":"Choose Image","slot_amount":7,"transition_rotation":0,"transition_duration":300,"delay":800,"enable_link":"false","link_type":"regular","link":"","link_open_in":"same","slide_link":"nothing","link_pos":"front","slide_thumb":"","image_id":"2787","slide_bg_color":"#E7E7E7","slide_bg_external":"","bg_fit":"cover","bg_fit_x":"100","bg_fit_y":"100","bg_repeat":"no-repeat","bg_position":"center center","bg_position_x":"0","bg_position_y":"0","image":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2013\/12\/ss-home-1-desktop-bg.jpg","kenburn_effect":"off","kb_start_fit":"100","kb_end_fit":"100","bg_end_position":"center top","kb_duration":"6000","kb_easing":"Linear.easeNone","0":"Choose Image"}',
					
					'layers' => 
						'[]'
				);

				// Slide 3
				$slides[] = array(
					'params' => 
						'{"background_type":"image","title":"End Graphics","state":"published","date_from":"","date_to":"","slide_transition":"fade","0":"Choose Image","slot_amount":7,"transition_rotation":0,"transition_duration":500,"delay":"","enable_link":"false","link_type":"regular","link":"","link_open_in":"same","slide_link":"nothing","link_pos":"front","slide_thumb":"","image_id":"2795","slide_bg_color":"#E7E7E7","slide_bg_external":"","bg_fit":"cover","bg_fit_x":"100","bg_fit_y":"100","bg_repeat":"no-repeat","bg_position":"center center","bg_position_x":"0","bg_position_y":"0","image":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2013\/12\/ss-home-1-desktop-blur-bg.jpg","0":"Choose Image","kenburn_effect":"off","kb_start_fit":"100","kb_end_fit":"100","bg_end_position":"center top","kb_duration":"6000","kb_easing":"Linear.easeNone"}',
					
					'layers' => 
						'[{"style":"","text":"Find Your Inspiration. Theme Features.","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2013\/12\/ss-home-1-features-button-alt.png","left":110,"top":120,"animation":"sfr","easing":"Power4.easeInOut","speed":750,"align_hor":"right","align_vert":"middle","hiddenunder":true,"resizeme":true,"link":"\/themes\/vellum-dev\/features\/","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":550,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":305,"height":285,"serial":"0","endTimeFinal":5250,"endSpeedFinal":300,"realEndTime":6000,"timeLast":5450,"alt":"Find Your Inspiration. Theme Features.","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""},{"style":"","text":"More","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2013\/12\/ss-home-1-down-arrow.png","left":0,"top":80,"animation":"sft","easing":"Power4.easeInOut","speed":500,"align_hor":"center","align_vert":"bottom","hiddenunder":false,"resizeme":true,"link":"#AfterSlider","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":1750,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":63,"height":63,"serial":"1","endTimeFinal":5500,"endSpeedFinal":300,"realEndTime":6000,"timeLast":4250,"alt":"More","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""}]'
				);

				// Loop through data and add to DB 
				// --------------------------------------------------
				$slide_order = 1;
				foreach ($slides as $slide) {
					$rows_affected = $wpdb->insert( $wpdb->prefix.'revslider_slides', 
						array(
							'slider_id' => $sliderID,
							'slide_order' => $slide_order,
							'params' => $slide['params'],
							'layers' => $slide['layers']
						)
					);
					$slide_order++;
				}

			}
										

			// Mark the database showing this has been done
			// --------------------------------------------------
			$rev_slider['slides'] = $slides;
			update_option( "slider_".$rev_slider["alias"], $rev_slider );

		} // if $slider_rows (slide show added)
	
	} // if !get_option( [theme]_[slider-alias] ) && !get_option( "slider_[slider-alias] )


	#================================================================================================================


	// ==================================================
	// Add Another Slide Show
	// ==================================================
	$rev_slider = array();
	$rev_slider["title"]  = 'Example';
	$rev_slider["alias"]  = 'example';
	$rev_slider["params"] = '{"title":"Example","alias":"example","shortcode":"[rev_slider example]","source_type":"gallery","post_types":"post","post_category":"category_5","post_sortby":"ID","posts_sort_direction":"DESC","max_slider_posts":"30","excerpt_limit":"55","slider_template_id":"","posts_list":"","slider_type":"fullwidth","fullscreen_offset_container":"","full_screen_align_force":"off","auto_height":"off","force_full_width":"off","responsitive_w1":"940","responsitive_sw1":"770","responsitive_w2":"780","responsitive_sw2":"500","responsitive_w3":"510","responsitive_sw3":"310","responsitive_w4":"0","responsitive_sw4":"0","responsitive_w5":"0","responsitive_sw5":"0","responsitive_w6":"0","responsitive_sw6":"0","width":"960","height":"425","delay":"9000","shuffle":"off","lazy_load":"off","use_wpml":"off","stop_slider":"off","stop_after_loops":0,"stop_at_slide":2,"load_googlefont":"false","google_font":[""],"position":"center","margin_top":0,"margin_bottom":0,"margin_left":0,"margin_right":0,"shadow_type":"1","show_timerbar":"bottom","padding":0,"background_color":"#E9E9E9","show_background_image":"false","background_image":"","bg_fit":"cover","bg_repeat":"no-repeat","bg_position":"center top","touchenabled":"on","stop_on_hover":"off","navigaion_type":"bullet","navigation_arrows":"solo","navigation_style":"round","navigaion_always_on":"false","hide_thumbs":200,"navigaion_align_hor":"center","navigaion_align_vert":"bottom","navigaion_offset_hor":"0","navigaion_offset_vert":20,"leftarrow_align_hor":"left","leftarrow_align_vert":"center","leftarrow_offset_hor":20,"leftarrow_offset_vert":0,"rightarrow_align_hor":"right","rightarrow_align_vert":"center","rightarrow_offset_hor":20,"rightarrow_offset_vert":0,"thumb_width":100,"thumb_height":50,"thumb_amount":5,"hide_slider_under":0,"hide_defined_layers_under":0,"hide_all_layers_under":0,"hide_thumbs_under_resolution":0,"start_with_slide":"1","first_transition_type":"fade","first_transition_duration":300,"first_transition_slot_amount":7,"jquery_noconflict":"on","js_to_body":"false","output_type":"none","template":"false","0":[""]}';
	
	if( !get_option( $shortname.$rev_slider["alias"] ) && !get_option( "slider_".$rev_slider["alias"] ) ) {

		$slider_rows = $wpdb->insert( $wpdb->prefix.'revslider_sliders', 
			array(
				'title' => $rev_slider["title"],
				'alias' => $rev_slider["alias"],
				'params' => $rev_slider["params"]
			)
		);


		if ($slider_rows) {

			// Get the new ID
			$sql = 'SELECT id FROM '. $wpdb->prefix .'revslider_sliders WHERE alias = "'. $rev_slider["alias"] .'" ;';
			$newSlider = $wpdb->get_results($sql);
			$sliderID = $newSlider[0]->id;


			// Add default Slides to Slide Show
			// --------------------------------------------------
			if ($sliderID) {

				$slides = array();

				// Slide 1
				$slides[] = array(
					'params' => 
						'{"background_type":"image","image":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/01\/unsplash_52c470899a2e1_1.jpg","image_id":"3711","title":"Slide","state":"published","date_from":"","date_to":"","slide_transition":"random","0":"Choose Image","slot_amount":7,"transition_rotation":0,"transition_duration":300,"delay":"","enable_link":"false","link_type":"regular","link":"","link_open_in":"same","slide_link":"nothing","link_pos":"front","slide_thumb":"","slide_bg_color":"#E7E7E7","slide_bg_external":"","bg_fit":"cover","bg_fit_x":"100","bg_fit_y":"100","bg_repeat":"no-repeat","bg_position":"center top","bg_position_x":"0","bg_position_y":"0","0":"Choose Image"}',
					
					'layers' => 
						'[{"style":"","text":"Image 1","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/01\/logo-alt-2.png","left":0,"top":0,"animation":"randomrotate","easing":"Power3.easeInOut","speed":300,"align_hor":"center","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":500,"endtime":"3000","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":325,"height":100,"serial":"0","endTimeFinal":3000,"endSpeedFinal":300,"realEndTime":3300,"timeLast":2800,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"","attrTitle":"","attrRel":""},{"style":"","text":"Image 2","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/01\/logo-2.png","left":43,"top":-10,"animation":"lft","easing":"Power3.easeInOut","speed":300,"align_hor":"center","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":3000,"endtime":"5500","endspeed":300,"endanimation":"ltb","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":325,"height":100,"serial":"1","endTimeFinal":5500,"endSpeedFinal":300,"realEndTime":5800,"timeLast":2800,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"","attrTitle":"","attrRel":""},{"style":"","text":"Image 3","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/01\/logo-3.png","left":0,"top":0,"animation":"lfl","easing":"Power3.easeInOut","speed":300,"align_hor":"center","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":5500,"endtime":"","endspeed":300,"endanimation":"skewtoright","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":325,"height":100,"serial":"2","endTimeFinal":8700,"endSpeedFinal":300,"realEndTime":9000,"timeLast":3500,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"","attrTitle":"","attrRel":""}]'
				);

				// Slide 2
				$slides[] = array(
					'params' => 
						'{"background_type":"image","image":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/01\/unsplash_52c36ef60f8df_1.jpg","image_id":"3438","title":"Slide","state":"published","date_from":"","date_to":"","slide_transition":"random","0":"Choose Image","slot_amount":7,"transition_rotation":0,"transition_duration":300,"delay":"","enable_link":"false","link_type":"regular","link":"","link_open_in":"same","slide_link":"nothing","link_pos":"front","slide_thumb":"","slide_bg_color":"#E7E7E7","slide_bg_external":"","bg_fit":"cover","bg_fit_x":"100","bg_fit_y":"100","bg_repeat":"no-repeat","bg_position":"center top","bg_position_x":"0","bg_position_y":"0","0":"Choose Image"}',
					
					'layers' => 
						'[{"style":"","text":"Image 1","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/01\/logo-alt-2.png","left":0,"top":0,"animation":"randomrotate","easing":"Power3.easeInOut","speed":300,"align_hor":"center","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":500,"endtime":"3000","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":325,"height":100,"serial":"0","endTimeFinal":3000,"endSpeedFinal":300,"realEndTime":3300,"timeLast":2800,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"","attrTitle":"","attrRel":""},{"style":"","text":"Image 2","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/01\/logo-2.png","left":43,"top":-10,"animation":"lft","easing":"Power3.easeInOut","speed":300,"align_hor":"center","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":3000,"endtime":"5500","endspeed":300,"endanimation":"ltb","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":325,"height":100,"serial":"1","endTimeFinal":5500,"endSpeedFinal":300,"realEndTime":5800,"timeLast":2800,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"","attrTitle":"","attrRel":""},{"style":"","text":"Image 3","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/01\/logo-3.png","left":0,"top":0,"animation":"lfl","easing":"Power3.easeInOut","speed":300,"align_hor":"center","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":5500,"endtime":"","endspeed":300,"endanimation":"skewtoright","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":325,"height":100,"serial":"2","endTimeFinal":8700,"endSpeedFinal":300,"realEndTime":9000,"timeLast":3500,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"","attrTitle":"","attrRel":""}]'
				);

				// Slide 3
				$slides[] = array(
					'params' => 
						'{"background_type":"image","image":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/01\/unsplash_52c56ffd153dd_1.jpg","image_id":"3712","title":"Slide","state":"published","date_from":"","date_to":"","slide_transition":"random","0":"Choose Image","slot_amount":7,"transition_rotation":0,"transition_duration":300,"delay":"","enable_link":"false","link_type":"regular","link":"","link_open_in":"same","slide_link":"nothing","link_pos":"front","slide_thumb":"","slide_bg_color":"#E7E7E7","slide_bg_external":"","bg_fit":"cover","bg_fit_x":"100","bg_fit_y":"100","bg_repeat":"no-repeat","bg_position":"center top","bg_position_x":"0","bg_position_y":"0","0":"Choose Image"}',
					
					'layers' => 
						'[{"style":"","text":"Image 1","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/01\/logo-alt-4.png","left":0,"top":0,"animation":"randomrotate","easing":"Power3.easeInOut","speed":300,"align_hor":"center","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":500,"endtime":"3000","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":325,"height":100,"serial":"0","endTimeFinal":3000,"endSpeedFinal":300,"realEndTime":3300,"timeLast":2800,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"","attrTitle":"","attrRel":""},{"style":"","text":"Image 2","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/01\/logo-2-alt-1.png","left":43,"top":-10,"animation":"lft","easing":"Power3.easeInOut","speed":300,"align_hor":"center","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":3000,"endtime":"5500","endspeed":300,"endanimation":"ltb","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":325,"height":100,"serial":"1","endTimeFinal":5500,"endSpeedFinal":300,"realEndTime":5800,"timeLast":2800,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"","attrTitle":"","attrRel":""},{"style":"","text":"Image 3","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/01\/logo-3-alt-1.png","left":0,"top":0,"animation":"lfl","easing":"Power3.easeInOut","speed":300,"align_hor":"center","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":5500,"endtime":"","endspeed":300,"endanimation":"skewtoright","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":325,"height":100,"serial":"2","endTimeFinal":8700,"endSpeedFinal":300,"realEndTime":9000,"timeLast":3500,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"","attrTitle":"","attrRel":""}]'
				);

				// Loop through data and add to DB 
				// --------------------------------------------------
				$slide_order = 1;
				foreach ($slides as $slide) {
					$rows_affected = $wpdb->insert( $wpdb->prefix.'revslider_slides', 
						array(
							'slider_id' => $sliderID,
							'slide_order' => $slide_order,
							'params' => $slide['params'],
							'layers' => $slide['layers']
						)
					);
					$slide_order++;
				}

			}
										

			// Mark the database showing this has been done
			// --------------------------------------------------
			$rev_slider['slides'] = $slides;
			update_option( "slider_".$rev_slider["alias"], $rev_slider );

		} // if $slider_rows (slide show added)
	
	} // if !get_option( [theme]_[slider-alias] ) && !get_option( "slider_[slider-alias] )


	#================================================================================================================


	// ==================================================
	// Add Another Slide Show
	// ==================================================
	$rev_slider = array();
	$rev_slider["title"]  = 'Example';
	$rev_slider["alias"]  = 'example';
	$rev_slider["params"] = '{"title":"Example","alias":"example","shortcode":"[rev_slider example]","source_type":"gallery","post_types":"post","post_category":"category_5","post_sortby":"ID","posts_sort_direction":"DESC","max_slider_posts":"30","excerpt_limit":"55","slider_template_id":"","posts_list":"","slider_type":"fullwidth","fullscreen_offset_container":"","full_screen_align_force":"off","auto_height":"off","force_full_width":"off","responsitive_w1":"940","responsitive_sw1":"770","responsitive_w2":"780","responsitive_sw2":"500","responsitive_w3":"510","responsitive_sw3":"310","responsitive_w4":"0","responsitive_sw4":"0","responsitive_w5":"0","responsitive_sw5":"0","responsitive_w6":"0","responsitive_sw6":"0","width":"960","height":"425","delay":"9000","shuffle":"off","lazy_load":"off","use_wpml":"off","stop_slider":"off","stop_after_loops":0,"stop_at_slide":2,"load_googlefont":"false","google_font":[""],"position":"center","margin_top":0,"margin_bottom":0,"margin_left":0,"margin_right":0,"shadow_type":"1","show_timerbar":"bottom","padding":0,"background_color":"#E9E9E9","show_background_image":"false","background_image":"","bg_fit":"cover","bg_repeat":"no-repeat","bg_position":"center top","touchenabled":"on","stop_on_hover":"off","navigaion_type":"bullet","navigation_arrows":"solo","navigation_style":"round","navigaion_always_on":"false","hide_thumbs":200,"navigaion_align_hor":"center","navigaion_align_vert":"bottom","navigaion_offset_hor":"0","navigaion_offset_vert":20,"leftarrow_align_hor":"left","leftarrow_align_vert":"center","leftarrow_offset_hor":20,"leftarrow_offset_vert":0,"rightarrow_align_hor":"right","rightarrow_align_vert":"center","rightarrow_offset_hor":20,"rightarrow_offset_vert":0,"thumb_width":100,"thumb_height":50,"thumb_amount":5,"hide_slider_under":0,"hide_defined_layers_under":0,"hide_all_layers_under":0,"hide_thumbs_under_resolution":0,"start_with_slide":"1","first_transition_type":"fade","first_transition_duration":300,"first_transition_slot_amount":7,"jquery_noconflict":"on","js_to_body":"false","output_type":"none","template":"false","0":[""]}';
	
	if( !get_option( $shortname.$rev_slider["alias"] ) && !get_option( "slider_".$rev_slider["alias"] ) ) {

		$slider_rows = $wpdb->insert( $wpdb->prefix.'revslider_sliders', 
			array(
				'title' => $rev_slider["title"],
				'alias' => $rev_slider["alias"],
				'params' => $rev_slider["params"]
			)
		);


		if ($slider_rows) {

			// Get the new ID
			$sql = 'SELECT id FROM '. $wpdb->prefix .'revslider_sliders WHERE alias = "'. $rev_slider["alias"] .'" ;';
			$newSlider = $wpdb->get_results($sql);
			$sliderID = $newSlider[0]->id;


			// Add default Slides to Slide Show
			// --------------------------------------------------
			if ($sliderID) {

				$slides = array();

				// Slide 1
				$slides[] = array(
					'params' => 
						'{"background_type":"image","image":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/01\/unsplash_52c470899a2e1_1.jpg","image_id":"3711","title":"Slide","state":"published","date_from":"","date_to":"","slide_transition":"random","0":"Choose Image","slot_amount":7,"transition_rotation":0,"transition_duration":300,"delay":"","enable_link":"false","link_type":"regular","link":"","link_open_in":"same","slide_link":"nothing","link_pos":"front","slide_thumb":"","slide_bg_color":"#E7E7E7","slide_bg_external":"","bg_fit":"cover","bg_fit_x":"100","bg_fit_y":"100","bg_repeat":"no-repeat","bg_position":"center top","bg_position_x":"0","bg_position_y":"0","0":"Choose Image"}',
					
					'layers' => 
						'[{"style":"","text":"Image 1","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/01\/logo-alt-2.png","left":0,"top":0,"animation":"randomrotate","easing":"Power3.easeInOut","speed":300,"align_hor":"center","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":500,"endtime":"3000","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":325,"height":100,"serial":"0","endTimeFinal":3000,"endSpeedFinal":300,"realEndTime":3300,"timeLast":2800,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"","attrTitle":"","attrRel":""},{"style":"","text":"Image 2","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/01\/logo-2.png","left":43,"top":-10,"animation":"lft","easing":"Power3.easeInOut","speed":300,"align_hor":"center","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":3000,"endtime":"5500","endspeed":300,"endanimation":"ltb","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":325,"height":100,"serial":"1","endTimeFinal":5500,"endSpeedFinal":300,"realEndTime":5800,"timeLast":2800,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"","attrTitle":"","attrRel":""},{"style":"","text":"Image 3","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/01\/logo-3.png","left":0,"top":0,"animation":"lfl","easing":"Power3.easeInOut","speed":300,"align_hor":"center","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":5500,"endtime":"","endspeed":300,"endanimation":"skewtoright","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":325,"height":100,"serial":"2","endTimeFinal":8700,"endSpeedFinal":300,"realEndTime":9000,"timeLast":3500,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"","attrTitle":"","attrRel":""}]'
				);

				// Slide 2
				$slides[] = array(
					'params' => 
						'{"background_type":"image","image":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/01\/unsplash_52c36ef60f8df_1.jpg","image_id":"3438","title":"Slide","state":"published","date_from":"","date_to":"","slide_transition":"random","0":"Choose Image","slot_amount":7,"transition_rotation":0,"transition_duration":300,"delay":"","enable_link":"false","link_type":"regular","link":"","link_open_in":"same","slide_link":"nothing","link_pos":"front","slide_thumb":"","slide_bg_color":"#E7E7E7","slide_bg_external":"","bg_fit":"cover","bg_fit_x":"100","bg_fit_y":"100","bg_repeat":"no-repeat","bg_position":"center top","bg_position_x":"0","bg_position_y":"0","0":"Choose Image"}',
					
					'layers' => 
						'[{"style":"","text":"Image 1","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/01\/logo-alt-2.png","left":0,"top":0,"animation":"randomrotate","easing":"Power3.easeInOut","speed":300,"align_hor":"center","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":500,"endtime":"3000","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":325,"height":100,"serial":"0","endTimeFinal":3000,"endSpeedFinal":300,"realEndTime":3300,"timeLast":2800,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"","attrTitle":"","attrRel":""},{"style":"","text":"Image 2","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/01\/logo-2.png","left":43,"top":-10,"animation":"lft","easing":"Power3.easeInOut","speed":300,"align_hor":"center","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":3000,"endtime":"5500","endspeed":300,"endanimation":"ltb","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":325,"height":100,"serial":"1","endTimeFinal":5500,"endSpeedFinal":300,"realEndTime":5800,"timeLast":2800,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"","attrTitle":"","attrRel":""},{"style":"","text":"Image 3","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/01\/logo-3.png","left":0,"top":0,"animation":"lfl","easing":"Power3.easeInOut","speed":300,"align_hor":"center","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":5500,"endtime":"","endspeed":300,"endanimation":"skewtoright","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":325,"height":100,"serial":"2","endTimeFinal":8700,"endSpeedFinal":300,"realEndTime":9000,"timeLast":3500,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"","attrTitle":"","attrRel":""}]'
				);

				// Slide 3
				$slides[] = array(
					'params' => 
						'{"background_type":"image","image":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/01\/unsplash_52c56ffd153dd_1.jpg","image_id":"3712","title":"Slide","state":"published","date_from":"","date_to":"","slide_transition":"random","0":"Choose Image","slot_amount":7,"transition_rotation":0,"transition_duration":300,"delay":"","enable_link":"false","link_type":"regular","link":"","link_open_in":"same","slide_link":"nothing","link_pos":"front","slide_thumb":"","slide_bg_color":"#E7E7E7","slide_bg_external":"","bg_fit":"cover","bg_fit_x":"100","bg_fit_y":"100","bg_repeat":"no-repeat","bg_position":"center top","bg_position_x":"0","bg_position_y":"0","0":"Choose Image"}',
					
					'layers' => 
						'[{"style":"","text":"Image 1","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/01\/logo-alt-4.png","left":0,"top":0,"animation":"randomrotate","easing":"Power3.easeInOut","speed":300,"align_hor":"center","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":500,"endtime":"3000","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":325,"height":100,"serial":"0","endTimeFinal":3000,"endSpeedFinal":300,"realEndTime":3300,"timeLast":2800,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"","attrTitle":"","attrRel":""},{"style":"","text":"Image 2","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/01\/logo-2-alt-1.png","left":43,"top":-10,"animation":"lft","easing":"Power3.easeInOut","speed":300,"align_hor":"center","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":3000,"endtime":"5500","endspeed":300,"endanimation":"ltb","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":325,"height":100,"serial":"1","endTimeFinal":5500,"endSpeedFinal":300,"realEndTime":5800,"timeLast":2800,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"","attrTitle":"","attrRel":""},{"style":"","text":"Image 3","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/01\/logo-3-alt-1.png","left":0,"top":0,"animation":"lfl","easing":"Power3.easeInOut","speed":300,"align_hor":"center","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":5500,"endtime":"","endspeed":300,"endanimation":"skewtoright","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":325,"height":100,"serial":"2","endTimeFinal":8700,"endSpeedFinal":300,"realEndTime":9000,"timeLast":3500,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"","attrTitle":"","attrRel":""}]'
				);

				// Loop through data and add to DB 
				// --------------------------------------------------
				$slide_order = 1;
				foreach ($slides as $slide) {
					$rows_affected = $wpdb->insert( $wpdb->prefix.'revslider_slides', 
						array(
							'slider_id' => $sliderID,
							'slide_order' => $slide_order,
							'params' => $slide['params'],
							'layers' => $slide['layers']
						)
					);
					$slide_order++;
				}

			}
										

			// Mark the database showing this has been done
			// --------------------------------------------------
			$rev_slider['slides'] = $slides;
			update_option( "slider_".$rev_slider["alias"], $rev_slider );

		} // if $slider_rows (slide show added)
	
	} // if !get_option( [theme]_[slider-alias] ) && !get_option( "slider_[slider-alias] )


	#================================================================================================================


	// ==================================================
	// Add Another Slide Show
	// ==================================================
	$rev_slider = array();
	$rev_slider["title"]  = 'Support Header';
	$rev_slider["alias"]  = 'support-header';
	$rev_slider["params"] = '{"title":"Support Header","alias":"support-header","shortcode":"[rev_slider support-header]","source_type":"gallery","post_types":"post","post_category":"category_5","post_sortby":"ID","posts_sort_direction":"DESC","max_slider_posts":"30","excerpt_limit":"55","slider_template_id":"","posts_list":"","slider_type":"fullwidth","fullscreen_offset_container":"","fullscreen_min_height":"","full_screen_align_force":"off","auto_height":"off","force_full_width":"off","width":"960","height":"375","responsitive_w1":"940","responsitive_sw1":"770","responsitive_w2":"780","responsitive_sw2":"500","responsitive_w3":"510","responsitive_sw3":"310","responsitive_w4":"0","responsitive_sw4":"0","responsitive_w5":"0","responsitive_sw5":"0","responsitive_w6":"0","responsitive_sw6":"0","delay":"9000","shuffle":"off","lazy_load":"off","use_wpml":"off","stop_slider":"on","stop_after_loops":0,"stop_at_slide":0,"load_googlefont":"true","google_font":["<link href=http:\/\/fonts.googleapis.com\/css?family=Open+Sans:300 rel=stylesheet type=text\/css>"],"position":"center","margin_top":0,"margin_bottom":0,"margin_left":0,"margin_right":0,"shadow_type":"0","show_timerbar":"hide","padding":0,"background_color":"#E9E9E9","background_dotted_overlay":"none","show_background_image":"false","background_image":"","bg_fit":"cover","bg_repeat":"no-repeat","bg_position":"center top","touchenabled":"off","stop_on_hover":"off","navigaion_type":"none","navigation_arrows":"nexttobullets","navigation_style":"round","navigaion_always_on":"false","hide_thumbs":200,"navigaion_align_hor":"center","navigaion_align_vert":"bottom","navigaion_offset_hor":"0","navigaion_offset_vert":20,"leftarrow_align_hor":"left","leftarrow_align_vert":"center","leftarrow_offset_hor":20,"leftarrow_offset_vert":0,"rightarrow_align_hor":"right","rightarrow_align_vert":"center","rightarrow_offset_hor":20,"rightarrow_offset_vert":0,"thumb_width":100,"thumb_height":50,"thumb_amount":5,"hide_slider_under":0,"hide_defined_layers_under":0,"hide_all_layers_under":0,"hide_thumbs_under_resolution":0,"start_with_slide":"1","first_transition_type":"fade","first_transition_duration":300,"first_transition_slot_amount":7,"reset_transitions":"","reset_transition_duration":0,"0":"Execute settings on all slides","jquery_noconflict":"on","js_to_body":"false","output_type":"none","template":"false"}';
	
	if( !get_option( $shortname.$rev_slider["alias"] ) && !get_option( "slider_".$rev_slider["alias"] ) ) {

		$slider_rows = $wpdb->insert( $wpdb->prefix.'revslider_sliders', 
			array(
				'title' => $rev_slider["title"],
				'alias' => $rev_slider["alias"],
				'params' => $rev_slider["params"]
			)
		);


		if ($slider_rows) {

			// Get the new ID
			$sql = 'SELECT id FROM '. $wpdb->prefix .'revslider_sliders WHERE alias = "'. $rev_slider["alias"] .'" ;';
			$newSlider = $wpdb->get_results($sql);
			$sliderID = $newSlider[0]->id;


			// Add default Slides to Slide Show
			// --------------------------------------------------
			if ($sliderID) {

				$slides = array();

				// Slide 1
				$slides[] = array(
					'params' => 
						'{"background_type":"image","image":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/01\/basket-bike-darker.jpg","image_id":"4234","title":"Slide","state":"published","date_from":"","date_to":"","slide_transition":"fade","0":"Choose Image","slot_amount":7,"transition_rotation":0,"transition_duration":300,"delay":"","enable_link":"false","link_type":"regular","link":"","link_open_in":"same","slide_link":"nothing","link_pos":"front","slide_thumb":"","slide_bg_color":"#E7E7E7","slide_bg_external":"","bg_fit":"cover","bg_fit_x":"100","bg_fit_y":"100","bg_repeat":"no-repeat","bg_position":"center center","bg_position_x":"0","bg_position_y":"0","kenburn_effect":"off","kb_start_fit":"100","kb_end_fit":"100","bg_end_position":"center top","kb_duration":"9000","kb_easing":"Linear.easeNone","0":"Choose Image"}',
					
					'layers' => 
						'[{"text":"<span style=\"font-size: 96px;\">Help and Support<\/span>","type":"text","left":0,"top":-10,"animation":"lft","easing":"Power3.easeInOut","speed":600,"align_hor":"center","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","style":"medium_light_white","time":1000,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":-1,"height":-1,"serial":"0","endTimeFinal":8400,"endSpeedFinal":300,"realEndTime":9000,"timeLast":8000,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""}]'
				);

				// Loop through data and add to DB 
				// --------------------------------------------------
				$slide_order = 1;
				foreach ($slides as $slide) {
					$rows_affected = $wpdb->insert( $wpdb->prefix.'revslider_slides', 
						array(
							'slider_id' => $sliderID,
							'slide_order' => $slide_order,
							'params' => $slide['params'],
							'layers' => $slide['layers']
						)
					);
					$slide_order++;
				}

			}
										

			// Mark the database showing this has been done
			// --------------------------------------------------
			$rev_slider['slides'] = $slides;
			update_option( "slider_".$rev_slider["alias"], $rev_slider );
		
		} // if $slider_rows (slide show added)

	} // if !get_option( [theme]_[slider-alias] ) && !get_option( "slider_[slider-alias] )


	#================================================================================================================


	// ==================================================
	// Add Another Slide Show
	// ==================================================
	$rev_slider = array();
	$rev_slider["title"]  = 'Resort and Spa';
	$rev_slider["alias"]  = 'one_page_resort';
	$rev_slider["params"] = '{"title":"Resort and Spa","alias":"one_page_resort","shortcode":"[rev_slider one_page_resort]","source_type":"gallery","post_types":"post","post_category":"category_5","post_sortby":"ID","posts_sort_direction":"DESC","max_slider_posts":"30","excerpt_limit":"55","slider_template_id":"","posts_list":"","slider_type":"fullscreen","fullscreen_offset_container":"","fullscreen_min_height":"","full_screen_align_force":"on","auto_height":"off","force_full_width":"off","width":"1300","height":"900","responsitive_w1":"940","responsitive_sw1":"770","responsitive_w2":"780","responsitive_sw2":"500","responsitive_w3":"510","responsitive_sw3":"310","responsitive_w4":"0","responsitive_sw4":"0","responsitive_w5":"0","responsitive_sw5":"0","responsitive_w6":"0","responsitive_sw6":"0","delay":"9000","shuffle":"off","lazy_load":"off","use_wpml":"off","stop_slider":"on","stop_after_loops":0,"stop_at_slide":1,"load_googlefont":"true","google_font":["<link href=http:\/\/fonts.googleapis.com\/css?family=Source+Sans+Pro:300,400,600,700,300italic,400italic,600italic,700italic rel=stylesheet type=text\/css>"],"position":"center","margin_top":0,"margin_bottom":0,"margin_left":0,"margin_right":0,"shadow_type":"0","show_timerbar":"hide","padding":0,"background_color":"#EDEAE8","background_dotted_overlay":"none","show_background_image":"false","background_image":"","bg_fit":"cover","bg_repeat":"no-repeat","bg_position":"center top","touchenabled":"off","stop_on_hover":"off","navigaion_type":"none","navigation_arrows":"solo","navigation_style":"round","navigaion_always_on":"false","hide_thumbs":200,"navigaion_align_hor":"center","navigaion_align_vert":"bottom","navigaion_offset_hor":"0","navigaion_offset_vert":20,"leftarrow_align_hor":"left","leftarrow_align_vert":"center","leftarrow_offset_hor":20,"leftarrow_offset_vert":0,"rightarrow_align_hor":"right","rightarrow_align_vert":"center","rightarrow_offset_hor":20,"rightarrow_offset_vert":0,"thumb_width":100,"thumb_height":50,"thumb_amount":5,"hide_slider_under":0,"hide_defined_layers_under":0,"hide_all_layers_under":0,"hide_thumbs_under_resolution":0,"start_with_slide":"1","first_transition_type":"fade","first_transition_duration":300,"first_transition_slot_amount":7,"reset_transitions":"","reset_transition_duration":0,"0":"Execute settings on all slides","jquery_noconflict":"on","js_to_body":"false","output_type":"none","template":"false"}';
	
	if( !get_option( $shortname.$rev_slider["alias"] ) && !get_option( "slider_".$rev_slider["alias"] ) ) {

		$slider_rows = $wpdb->insert( $wpdb->prefix.'revslider_sliders', 
			array(
				'title' => $rev_slider["title"],
				'alias' => $rev_slider["alias"],
				'params' => $rev_slider["params"]
			)
		);


		if ($slider_rows) {

			// Get the new ID
			$sql = 'SELECT id FROM '. $wpdb->prefix .'revslider_sliders WHERE alias = "'. $rev_slider["alias"] .'" ;';
			$newSlider = $wpdb->get_results($sql);
			$sliderID = $newSlider[0]->id;


			// Add default Slides to Slide Show
			// --------------------------------------------------
			if ($sliderID) {

				$slides = array();

				// Slide 1
				$slides[] = array(
					'params' => 
						'{"background_type":"image","image":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/01\/resort-spa-walking-away.jpg","image_id":"4399","title":"Slide","state":"published","date_from":"","date_to":"","slide_transition":"fade","0":"Choose Image","slot_amount":7,"transition_rotation":0,"transition_duration":300,"delay":1500,"enable_link":"false","link_type":"regular","link":"","link_open_in":"same","slide_link":"nothing","link_pos":"front","slide_thumb":"","slide_bg_color":"#E7E7E7","slide_bg_external":"","bg_fit":"cover","bg_fit_x":"100","bg_fit_y":"100","bg_repeat":"no-repeat","bg_position":"center center","bg_position_x":"0","bg_position_y":"0","kenburn_effect":"off","kb_start_fit":"200","kb_end_fit":"100","bg_end_position":"center center","kb_duration":"14205","kb_easing":"Linear.easeNone","0":"Choose Image"}',
					
					'layers' => 
						'[{"text":"<div style=\"text-align:right;font-weight:600;font-size:120px;line-height:105px;color:#fff;\">RELAX<br>\nYOUR<br>\nSENSES<\/div>","type":"text","left":75,"top":0,"animation":"sfr","easing":"Power3.easeInOut","speed":1100,"align_hor":"right","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","style":"large_bold_white","time":500,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":-1,"height":-1,"serial":"0","endTimeFinal":7900,"endSpeedFinal":300,"realEndTime":9000,"timeLast":8500,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"hidden-phone","attrTitle":"","attrRel":""},{"text":"<div style=\"font-weight:800;font-size:120px;line-height:105px;color:#fff;\">RELAX YOUR SENSES<\/div>","type":"text","left":0,"top":115,"animation":"sft","easing":"Power3.easeInOut","speed":1500,"align_hor":"center","align_vert":"bottom","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","style":"large_bold_white","time":650,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":396,"height":315,"serial":"1","endTimeFinal":7500,"endSpeedFinal":300,"realEndTime":9000,"timeLast":8350,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"visible-phone","attrTitle":"","attrRel":""},{"style":"","text":"Quote - Spa+","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/resort-spa-press-quote-1.png","left":120,"top":20,"animation":"sfl","easing":"Power1.easeOut","speed":500,"align_hor":"center","align_vert":"bottom","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":1500,"endtime":"4000","endspeed":800,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":700,"height":215,"serial":"2","endTimeFinal":4000,"endSpeedFinal":800,"realEndTime":4800,"timeLast":3300,"alt":"Quote - Spa+","scaleX":"700","scaleY":"215","scaleProportional":true,"attrID":"","attrClasses":"hidden-phone","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""},{"style":"","text":"Quote - Nuvo","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/resort-spa-press-quote-3.png","left":120,"top":20,"animation":"sfr","easing":"Power1.easeOut","speed":500,"align_hor":"center","align_vert":"bottom","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":4500,"endtime":"7000","endspeed":800,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":700,"height":215,"serial":"3","endTimeFinal":7000,"endSpeedFinal":800,"realEndTime":7800,"timeLast":3300,"alt":"Quote - Nuvo","scaleX":"700","scaleY":"215","scaleProportional":true,"attrID":"","attrClasses":"hidden-phone","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""},{"style":"","text":"Quote - Yoga Mag","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/resort-spa-press-quote-4.png","left":120,"top":20,"animation":"sfl","easing":"Power1.easeOut","speed":500,"align_hor":"center","align_vert":"bottom","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":7500,"endtime":"10000","endspeed":800,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":700,"height":215,"serial":"4","endTimeFinal":10000,"endSpeedFinal":800,"realEndTime":10800,"timeLast":3300,"alt":"Quote - Yoga Mag","scaleX":"700","scaleY":"215","scaleProportional":true,"attrID":"","attrClasses":"hidden-phone","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""},{"style":"","text":"Quote - California Homes","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/resort-spa-press-quote-2.png","left":120,"top":20,"animation":"sfr","easing":"Power1.easeOut","speed":500,"align_hor":"center","align_vert":"bottom","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":10500,"endtime":"","endspeed":800,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":700,"height":215,"serial":"5","endTimeFinal":1000,"endSpeedFinal":800,"realEndTime":1500,"timeLast":-9000,"alt":"Quote - California Homes","scaleX":"700","scaleY":"215","scaleProportional":true,"attrID":"","attrClasses":"hidden-phone","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""}]'
				);

				// Loop through data and add to DB 
				// --------------------------------------------------
				$slide_order = 1;
				foreach ($slides as $slide) {
					$rows_affected = $wpdb->insert( $wpdb->prefix.'revslider_slides', 
						array(
							'slider_id' => $sliderID,
							'slide_order' => $slide_order,
							'params' => $slide['params'],
							'layers' => $slide['layers']
						)
					);
					$slide_order++;
				}

			}
										

			// Mark the database showing this has been done
			// --------------------------------------------------
			$rev_slider['slides'] = $slides;
			update_option( "slider_".$rev_slider["alias"], $rev_slider );
		
		} // if $slider_rows (slide show added)

	} // if !get_option( [theme]_[slider-alias] ) && !get_option( "slider_[slider-alias] )


	#================================================================================================================


	// ==================================================
	// Add Another Slide Show
	// ==================================================
	$rev_slider = array();
	$rev_slider["title"]  = 'wine';
	$rev_slider["alias"]  = 'wine';
	$rev_slider["params"] = '{"title":"wine","alias":"wine","shortcode":"[rev_slider wine]","source_type":"gallery","post_types":"post","post_category":"category_5","post_sortby":"ID","posts_sort_direction":"DESC","max_slider_posts":"30","excerpt_limit":"55","slider_template_id":"","posts_list":"","slider_type":"fullscreen","fullscreen_offset_container":"","fullscreen_min_height":"","full_screen_align_force":"on","auto_height":"off","force_full_width":"off","width":"1300","height":"900","responsitive_w1":"940","responsitive_sw1":"770","responsitive_w2":"780","responsitive_sw2":"500","responsitive_w3":"510","responsitive_sw3":"310","responsitive_w4":"0","responsitive_sw4":"0","responsitive_w5":"0","responsitive_sw5":"0","responsitive_w6":"0","responsitive_sw6":"0","delay":"6000","shuffle":"off","lazy_load":"off","use_wpml":"off","stop_slider":"on","stop_after_loops":0,"stop_at_slide":2,"load_googlefont":"false","google_font":["<link href=http:\/\/fonts.googleapis.com\/css?family=PT+Sans+Narrow:400,700 rel=stylesheet type=text\/css>"],"position":"center","margin_top":0,"margin_bottom":0,"margin_left":0,"margin_right":0,"shadow_type":"0","show_timerbar":"hide","padding":0,"background_color":"#393939","background_dotted_overlay":"none","show_background_image":"false","background_image":"","bg_fit":"cover","bg_repeat":"no-repeat","bg_position":"center top","touchenabled":"off","stop_on_hover":"off","navigaion_type":"none","navigation_arrows":"none","navigation_style":"round","navigaion_always_on":"false","hide_thumbs":200,"navigaion_align_hor":"center","navigaion_align_vert":"bottom","navigaion_offset_hor":"0","navigaion_offset_vert":20,"leftarrow_align_hor":"left","leftarrow_align_vert":"center","leftarrow_offset_hor":20,"leftarrow_offset_vert":0,"rightarrow_align_hor":"right","rightarrow_align_vert":"center","rightarrow_offset_hor":20,"rightarrow_offset_vert":0,"thumb_width":100,"thumb_height":50,"thumb_amount":5,"hide_slider_under":0,"hide_defined_layers_under":0,"hide_all_layers_under":0,"hide_arrows_on_mobile":"off","hide_bullets_on_mobile":"off","hide_thumbs_on_mobile":"off","hide_thumbs_under_resolution":0,"start_with_slide":"1","first_transition_active":"false","first_transition_type":"fade","first_transition_duration":300,"first_transition_slot_amount":7,"reset_transitions":"","reset_transition_duration":0,"0":"Execute settings on all slides","jquery_noconflict":"on","js_to_body":"false","output_type":"none","template":"false"}';
	
	if( !get_option( $shortname.$rev_slider["alias"] ) && !get_option( "slider_".$rev_slider["alias"] ) ) {

		$slider_rows = $wpdb->insert( $wpdb->prefix.'revslider_sliders', 
			array(
				'title' => $rev_slider["title"],
				'alias' => $rev_slider["alias"],
				'params' => $rev_slider["params"]
			)
		);


		if ($slider_rows) {

			// Get the new ID
			$sql = 'SELECT id FROM '. $wpdb->prefix .'revslider_sliders WHERE alias = "'. $rev_slider["alias"] .'" ;';
			$newSlider = $wpdb->get_results($sql);
			$sliderID = $newSlider[0]->id;


			// Add default Slides to Slide Show
			// --------------------------------------------------
			if ($sliderID) {

				$slides = array();

				// Slide 1
				$slides[] = array(
					'params' => 
						'{"background_type":"image","title":"Slide","state":"published","date_from":"","date_to":"","slide_transition":"fade","0":"Choose Image","slot_amount":7,"transition_rotation":0,"transition_duration":500,"delay":500,"enable_link":"false","link_type":"regular","link":"","link_open_in":"same","slide_link":"nothing","link_pos":"front","slide_thumb":"","image_id":"4774","slide_bg_color":"#E7E7E7","slide_bg_external":"","bg_fit":"cover","bg_fit_x":"100","bg_fit_y":"100","bg_repeat":"no-repeat","bg_position":"center center","bg_position_x":"0","bg_position_y":"0","kenburn_effect":"off","kb_start_fit":"100","kb_end_fit":"100","bg_end_position":"center top","kb_duration":"9000","kb_easing":"Linear.easeNone","image":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/winebg.jpg","0":"Choose Image"}',
					
					'layers' => 
						'[]'
				);

				// Slide 2
				$slides[] = array(
					'params' => 
						'{"background_type":"image","title":"With Graphics","state":"published","date_from":"","date_to":"","slide_transition":"fade","0":"Choose Image","slot_amount":7,"transition_rotation":0,"transition_duration":300,"delay":"","enable_link":"false","link_type":"regular","link":"","link_open_in":"same","slide_link":"nothing","link_pos":"front","slide_thumb":"","image_id":"4774","slide_bg_color":"#E7E7E7","slide_bg_external":"","bg_fit":"cover","bg_fit_x":"100","bg_fit_y":"100","bg_repeat":"no-repeat","bg_position":"center center","bg_position_x":"0","bg_position_y":"0","kenburn_effect":"off","kb_start_fit":"100","kb_end_fit":"100","bg_end_position":"center top","kb_duration":"9000","kb_easing":"Linear.easeNone","image":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/winebg.jpg","0":"Choose Image"}',
					
					'layers' => 
						'[{"style":"","text":"Image 1","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/big.png","left":-403,"top":0,"animation":"sfb","easing":"Power3.easeInOut","speed":800,"align_hor":"center","align_vert":"bottom","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":500,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":231,"height":765,"serial":"0","endTimeFinal":5200,"endSpeedFinal":300,"realEndTime":6000,"timeLast":5500,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"visible-desktop","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""},{"style":"","text":"Image 2","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/bigger.png","left":-115,"top":-5,"animation":"sfb","easing":"Power3.easeInOut","speed":300,"align_hor":"center","align_vert":"bottom","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":800,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":246,"height":813,"serial":"1","endTimeFinal":5700,"endSpeedFinal":300,"realEndTime":6000,"timeLast":5200,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"visible-desktop","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""},{"style":"","text":"Image 3","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/biggest.png","left":-250,"top":-5,"animation":"sfb","easing":"Power3.easeInOut","speed":300,"align_hor":"center","align_vert":"bottom","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":1100,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":277,"height":963,"serial":"2","endTimeFinal":5700,"endSpeedFinal":300,"realEndTime":6000,"timeLast":4900,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"visible-desktop","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""},{"style":"","text":"Image 4","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/vellum.png","left":175,"top":115,"animation":"sft","easing":"Power3.easeInOut","speed":300,"align_hor":"right","align_vert":"top","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":1400,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":478,"height":203,"serial":"3","endTimeFinal":5700,"endSpeedFinal":300,"realEndTime":6000,"timeLast":4600,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"visible-desktop","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""},{"style":"","text":"Image 5","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/subtitle.png","left":190,"top":317,"animation":"sfb","easing":"Power3.easeInOut","speed":300,"align_hor":"right","align_vert":"top","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":1700,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":419,"height":32,"serial":"4","endTimeFinal":5700,"endSpeedFinal":300,"realEndTime":6000,"timeLast":4300,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"visible-desktop","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""},{"style":"","text":"Image 6","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/divtop.png","left":175,"top":360,"animation":"sft","easing":"Power3.easeInOut","speed":300,"align_hor":"right","align_vert":"top","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":2000,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":447,"height":22,"serial":"5","endTimeFinal":5700,"endSpeedFinal":300,"realEndTime":6000,"timeLast":4000,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"visible-desktop","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""},{"style":"","text":"Image 7","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/div_bottom.png","left":175,"top":523,"animation":"sfb","easing":"Power3.easeInOut","speed":300,"align_hor":"right","align_vert":"top","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":2300,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":437,"height":13,"serial":"6","endTimeFinal":5700,"endSpeedFinal":300,"realEndTime":6000,"timeLast":3700,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"visible-desktop","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""},{"style":"","text":"Image 8","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/price.png","left":205,"top":384,"animation":"tp-fade","easing":"Power3.easeInOut","speed":300,"align_hor":"right","align_vert":"top","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":2600,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":387,"height":124,"serial":"7","endTimeFinal":5700,"endSpeedFinal":300,"realEndTime":6000,"timeLast":3400,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"visible-desktop","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""},{"style":"","text":"Image 9","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/winerysince.png","left":260,"top":540,"animation":"lfb","easing":"Power3.easeInOut","speed":900,"align_hor":"right","align_vert":"top","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":2900,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":275,"height":79,"serial":"8","endTimeFinal":5100,"endSpeedFinal":300,"realEndTime":6000,"timeLast":3100,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"visible-desktop","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""},{"style":"","text":"Bottle (mobile only)","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/biggest.png","left":0,"top":-5,"animation":"sfb","easing":"Power3.easeInOut","speed":800,"align_hor":"center","align_vert":"bottom","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":500,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":277,"height":963,"serial":"9","endTimeFinal":5200,"endSpeedFinal":300,"realEndTime":6000,"timeLast":5500,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"hidden-desktop","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""},{"style":"","text":"Logo (mobile only)","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/vellum.png","left":0,"top":-100,"animation":"sft","easing":"Power3.easeInOut","speed":500,"align_hor":"center","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":1100,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":478,"height":203,"serial":"10","endTimeFinal":5500,"endSpeedFinal":300,"realEndTime":6000,"timeLast":4900,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"hidden-desktop","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""}]'
				);

				// Loop through data and add to DB 
				// --------------------------------------------------
				$slide_order = 1;
				foreach ($slides as $slide) {
					$rows_affected = $wpdb->insert( $wpdb->prefix.'revslider_slides', 
						array(
							'slider_id' => $sliderID,
							'slide_order' => $slide_order,
							'params' => $slide['params'],
							'layers' => $slide['layers']
						)
					);
					$slide_order++;
				}

			}
										

			// Mark the database showing this has been done
			// --------------------------------------------------
			$rev_slider['slides'] = $slides;
			update_option( "slider_".$rev_slider["alias"], $rev_slider );
		
		} // if $slider_rows (slide show added)

	} // if !get_option( [theme]_[slider-alias] ) && !get_option( "slider_[slider-alias] )


	#================================================================================================================


	// ==================================================
	// Add Another Slide Show
	// ==================================================
	$rev_slider = array();
	$rev_slider["title"]  = 'business';
	$rev_slider["alias"]  = 'business';
	$rev_slider["params"] = '{"title":"business","alias":"business","shortcode":"[rev_slider business]","source_type":"gallery","post_types":"post","post_category":"category_5","post_sortby":"ID","posts_sort_direction":"DESC","max_slider_posts":"30","excerpt_limit":"55","slider_template_id":"","posts_list":"","slider_type":"fullscreen","fullscreen_offset_container":"#masthead","fullscreen_min_height":"","full_screen_align_force":"on","auto_height":"off","force_full_width":"on","width":"1300","height":"700","responsitive_w1":"940","responsitive_sw1":"770","responsitive_w2":"780","responsitive_sw2":"500","responsitive_w3":"510","responsitive_sw3":"310","responsitive_w4":"0","responsitive_sw4":"0","responsitive_w5":"0","responsitive_sw5":"0","responsitive_w6":"0","responsitive_sw6":"0","delay":"6000","shuffle":"off","lazy_load":"off","use_wpml":"off","stop_slider":"off","stop_after_loops":0,"stop_at_slide":2,"load_googlefont":"false","google_font":["<link href=http:\/\/fonts.googleapis.com\/css?family=PT+Sans+Narrow:400,700 rel=stylesheet type=text\/css>"],"position":"center","margin_top":0,"margin_bottom":0,"margin_left":0,"margin_right":0,"shadow_type":"0","show_timerbar":"hide","padding":0,"background_color":"#393939","background_dotted_overlay":"none","show_background_image":"false","background_image":"","bg_fit":"cover","bg_repeat":"no-repeat","bg_position":"center top","touchenabled":"off","stop_on_hover":"off","navigaion_type":"bullet","navigation_arrows":"solo","navigation_style":"round","navigaion_always_on":"false","hide_thumbs":200,"navigaion_align_hor":"center","navigaion_align_vert":"bottom","navigaion_offset_hor":"0","navigaion_offset_vert":20,"leftarrow_align_hor":"left","leftarrow_align_vert":"center","leftarrow_offset_hor":20,"leftarrow_offset_vert":0,"rightarrow_align_hor":"right","rightarrow_align_vert":"center","rightarrow_offset_hor":20,"rightarrow_offset_vert":0,"thumb_width":100,"thumb_height":50,"thumb_amount":5,"hide_slider_under":0,"hide_defined_layers_under":0,"hide_all_layers_under":0,"hide_thumbs_under_resolution":0,"start_with_slide":"1","first_transition_type":"fade","first_transition_duration":300,"first_transition_slot_amount":7,"reset_transitions":"","reset_transition_duration":0,"0":"Execute settings on all slides","jquery_noconflict":"on","js_to_body":"false","output_type":"none","template":"false"}';
	
	if( !get_option( $shortname.$rev_slider["alias"] ) && !get_option( "slider_".$rev_slider["alias"] ) ) {

		$slider_rows = $wpdb->insert( $wpdb->prefix.'revslider_sliders', 
			array(
				'title' => $rev_slider["title"],
				'alias' => $rev_slider["alias"],
				'params' => $rev_slider["params"]
			)
		);


		if ($slider_rows) {

			// Get the new ID
			$sql = 'SELECT id FROM '. $wpdb->prefix .'revslider_sliders WHERE alias = "'. $rev_slider["alias"] .'" ;';
			$newSlider = $wpdb->get_results($sql);
			$sliderID = $newSlider[0]->id;


			// Add default Slides to Slide Show
			// --------------------------------------------------
			if ($sliderID) {

				$slides = array();

				// Slide 1
				$slides[] = array(
					'params' => 
						'{"background_type":"image","title":"Slide","state":"published","date_from":"","date_to":"","slide_transition":"zoomout","0":"Choose Image","slot_amount":7,"transition_rotation":0,"transition_duration":300,"delay":"","enable_link":"false","link_type":"regular","link":"","link_open_in":"same","slide_link":"nothing","link_pos":"front","slide_thumb":"","image_id":"4795","slide_bg_color":"#E7E7E7","slide_bg_external":"","bg_fit":"cover","bg_fit_x":"100","bg_fit_y":"100","bg_repeat":"no-repeat","bg_position":"center top","bg_position_x":"0","bg_position_y":"0","kenburn_effect":"off","kb_start_fit":"100","kb_end_fit":"100","bg_end_position":"center top","kb_duration":"9000","kb_easing":"Linear.easeNone","image":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/02\/slide1.jpg","0":"Choose Image"}',
					
					'layers' => 
						'[]'
				);

				// Slide 2
				$slides[] = array(
					'params' => 
						'{"background_type":"image","title":"Slide","state":"published","date_from":"","date_to":"","slide_transition":"zoomout","0":"Choose Image","slot_amount":7,"transition_rotation":0,"transition_duration":300,"delay":"","enable_link":"false","link_type":"regular","link":"","link_open_in":"same","slide_link":"nothing","link_pos":"front","slide_thumb":"","image_id":"4796","slide_bg_color":"#E7E7E7","slide_bg_external":"","bg_fit":"cover","bg_fit_x":"100","bg_fit_y":"100","bg_repeat":"no-repeat","bg_position":"center top","bg_position_x":"0","bg_position_y":"0","kenburn_effect":"off","kb_start_fit":"100","kb_end_fit":"100","bg_end_position":"center top","kb_duration":"6000","kb_easing":"Linear.easeNone","image":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/02\/SLide2.jpg","0":"Choose Image"}',
					
					'layers' => 
						'[]'
				);

				// Slide 3
				$slides[] = array(
					'params' => 
						'{"background_type":"image","title":"Slide","state":"published","date_from":"","date_to":"","slide_transition":"zoomout","0":"Choose Image","slot_amount":7,"transition_rotation":0,"transition_duration":300,"delay":"","enable_link":"false","link_type":"regular","link":"","link_open_in":"same","slide_link":"nothing","link_pos":"front","slide_thumb":"","image_id":"4797","slide_bg_color":"#E7E7E7","slide_bg_external":"","bg_fit":"cover","bg_fit_x":"100","bg_fit_y":"100","bg_repeat":"no-repeat","bg_position":"center top","bg_position_x":"0","bg_position_y":"0","kenburn_effect":"off","kb_start_fit":"100","kb_end_fit":"100","bg_end_position":"center top","kb_duration":"6000","kb_easing":"Linear.easeNone","image":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/02\/slide3.jpg","0":"Choose Image"}',
					
					'layers' => 
						'[]'
				);

				// Loop through data and add to DB 
				// --------------------------------------------------
				$slide_order = 1;
				foreach ($slides as $slide) {
					$rows_affected = $wpdb->insert( $wpdb->prefix.'revslider_slides', 
						array(
							'slider_id' => $sliderID,
							'slide_order' => $slide_order,
							'params' => $slide['params'],
							'layers' => $slide['layers']
						)
					);
					$slide_order++;
				}

			}
										

			// Mark the database showing this has been done
			// --------------------------------------------------
			$rev_slider['slides'] = $slides;
			update_option( "slider_".$rev_slider["alias"], $rev_slider );
		
		} // if $slider_rows (slide show added)

	} // if !get_option( [theme]_[slider-alias] ) && !get_option( "slider_[slider-alias] )


	#================================================================================================================


	// ==================================================
	// Add Another Slide Show
	// ==================================================
	$rev_slider = array();
	$rev_slider["title"]  = 'Creative Studio';
	$rev_slider["alias"]  = 'portfolio-home';
	$rev_slider["params"] = '{"title":"Creative Studio","alias":"portfolio-home","shortcode":"[rev_slider portfolio-home]","source_type":"gallery","post_types":"post","post_category":"category_5","post_sortby":"ID","posts_sort_direction":"DESC","max_slider_posts":"30","excerpt_limit":"55","slider_template_id":"","posts_list":"","slider_type":"fullscreen","fullscreen_offset_container":"","fullscreen_min_height":"","full_screen_align_force":"on","auto_height":"off","force_full_width":"off","width":"960","height":"350","responsitive_w1":"940","responsitive_sw1":"770","responsitive_w2":"780","responsitive_sw2":"500","responsitive_w3":"510","responsitive_sw3":"310","responsitive_w4":"0","responsitive_sw4":"0","responsitive_w5":"0","responsitive_sw5":"0","responsitive_w6":"0","responsitive_sw6":"0","delay":"6000","shuffle":"off","lazy_load":"off","use_wpml":"off","stop_slider":"off","stop_after_loops":0,"stop_at_slide":2,"load_googlefont":"false","google_font":"","position":"center","margin_top":0,"margin_bottom":0,"margin_left":0,"margin_right":0,"shadow_type":"0","show_timerbar":"bottom","padding":0,"background_color":"#3e3b3e","background_dotted_overlay":"twoxtwo","show_background_image":"false","background_image":"","bg_fit":"cover","bg_repeat":"no-repeat","bg_position":"center top","touchenabled":"on","stop_on_hover":"on","navigaion_type":"none","navigation_arrows":"none","navigation_style":"round","navigaion_always_on":"false","hide_thumbs":200,"navigaion_align_hor":"center","navigaion_align_vert":"bottom","navigaion_offset_hor":"0","navigaion_offset_vert":20,"leftarrow_align_hor":"left","leftarrow_align_vert":"center","leftarrow_offset_hor":20,"leftarrow_offset_vert":0,"rightarrow_align_hor":"right","rightarrow_align_vert":"center","rightarrow_offset_hor":20,"rightarrow_offset_vert":0,"thumb_width":100,"thumb_height":50,"thumb_amount":5,"hide_slider_under":0,"hide_defined_layers_under":0,"hide_all_layers_under":0,"hide_thumbs_under_resolution":0,"start_with_slide":"1","first_transition_type":"fade","first_transition_duration":300,"first_transition_slot_amount":7,"reset_transitions":"","reset_transition_duration":0,"0":"Execute settings on all slides","jquery_noconflict":"on","js_to_body":"false","output_type":"none","template":"false"}';
	
	if( !get_option( $shortname.$rev_slider["alias"] ) && !get_option( "slider_".$rev_slider["alias"] ) ) {

		$slider_rows = $wpdb->insert( $wpdb->prefix.'revslider_sliders', 
			array(
				'title' => $rev_slider["title"],
				'alias' => $rev_slider["alias"],
				'params' => $rev_slider["params"]
			)
		);


		if ($slider_rows) {

			// Get the new ID
			$sql = 'SELECT id FROM '. $wpdb->prefix .'revslider_sliders WHERE alias = "'. $rev_slider["alias"] .'" ;';
			$newSlider = $wpdb->get_results($sql);
			$sliderID = $newSlider[0]->id;


			// Add default Slides to Slide Show
			// --------------------------------------------------
			if ($sliderID) {

				$slides = array();

				// Slide 1
				$slides[] = array(
					'params' => 
						'{"background_type":"image","image":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/02\/man-walking-in-street.jpg","image_id":"4929","title":"Slide","state":"published","date_from":"","date_to":"","slide_transition":"random","0":"Choose Image","slot_amount":7,"transition_rotation":0,"transition_duration":300,"delay":"","enable_link":"false","link_type":"regular","link":"","link_open_in":"same","slide_link":"nothing","link_pos":"front","slide_thumb":"","slide_bg_color":"#E7E7E7","slide_bg_external":"","bg_fit":"cover","bg_fit_x":"100","bg_fit_y":"100","bg_repeat":"no-repeat","bg_position":"center center","bg_position_x":"0","bg_position_y":"0","kenburn_effect":"off","kb_start_fit":"100","kb_end_fit":"100","bg_end_position":"center top","kb_duration":"9000","kb_easing":"Linear.easeNone"}',
					
					'layers' => 
						'[]'
				);

				// Slide 2
				$slides[] = array(
					'params' => 
						'{"background_type":"image","image":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/02\/mountain-view-across-lake.jpg","image_id":"4930","title":"Slide","state":"published","date_from":"","date_to":"","slide_transition":"random","0":"Choose Image","slot_amount":7,"transition_rotation":0,"transition_duration":300,"delay":"","enable_link":"false","link_type":"regular","link":"","link_open_in":"same","slide_link":"nothing","link_pos":"front","slide_thumb":"","slide_bg_color":"#E7E7E7","slide_bg_external":"","bg_fit":"cover","bg_fit_x":"100","bg_fit_y":"100","bg_repeat":"no-repeat","bg_position":"center center","bg_position_x":"0","bg_position_y":"0","kenburn_effect":"off","kb_start_fit":"100","kb_end_fit":"100","bg_end_position":"center top","kb_duration":"9000","kb_easing":"Linear.easeNone","0":"Choose Image"}',
					
					'layers' => 
						'[]'
				);

				// Slide 3
				$slides[] = array(
					'params' => 
						'{"background_type":"image","image":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/02\/animal-on-sand.jpg","image_id":"4928","title":"Slide","state":"published","date_from":"","date_to":"","slide_transition":"random","0":"Choose Image","slot_amount":7,"transition_rotation":0,"transition_duration":300,"delay":"","enable_link":"false","link_type":"regular","link":"","link_open_in":"same","slide_link":"nothing","link_pos":"front","slide_thumb":"","slide_bg_color":"#E7E7E7","slide_bg_external":"","bg_fit":"cover","bg_fit_x":"100","bg_fit_y":"100","bg_repeat":"no-repeat","bg_position":"center center","bg_position_x":"0","bg_position_y":"0","kenburn_effect":"off","kb_start_fit":"100","kb_end_fit":"100","bg_end_position":"center top","kb_duration":"9000","kb_easing":"Linear.easeNone"}',
					
					'layers' => 
						'[]'
				);

				// Slide 4
				$slides[] = array(
					'params' => 
						'{"background_type":"image","image":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/02\/pile-of-logs.jpg","image_id":"4927","title":"Slide","state":"published","date_from":"","date_to":"","slide_transition":"random","0":"Choose Image","slot_amount":7,"transition_rotation":0,"transition_duration":300,"delay":"","enable_link":"false","link_type":"regular","link":"","link_open_in":"same","slide_link":"nothing","link_pos":"front","slide_thumb":"","slide_bg_color":"#E7E7E7","slide_bg_external":"","bg_fit":"cover","bg_fit_x":"100","bg_fit_y":"100","bg_repeat":"no-repeat","bg_position":"center center","bg_position_x":"0","bg_position_y":"0","kenburn_effect":"off","kb_start_fit":"100","kb_end_fit":"100","bg_end_position":"center top","kb_duration":"9000","kb_easing":"Linear.easeNone"}',
					
					'layers' => 
						'[]'
				);

				// Slide 5
				$slides[] = array(
					'params' => 
						'{"background_type":"image","image":"http:\/\/para.llel.us\/themes\/vellum-dev\/wp-content\/uploads\/2014\/02\/ocean-between-clifs.jpg","image_id":"4931","title":"Slide","state":"published","date_from":"","date_to":"","slide_transition":"random","0":"Choose Image","slot_amount":7,"transition_rotation":0,"transition_duration":300,"delay":"","enable_link":"false","link_type":"regular","link":"","link_open_in":"same","slide_link":"nothing","link_pos":"front","slide_thumb":"","slide_bg_color":"#E7E7E7","slide_bg_external":"","bg_fit":"cover","bg_fit_x":"100","bg_fit_y":"100","bg_repeat":"no-repeat","bg_position":"center center","bg_position_x":"0","bg_position_y":"0","kenburn_effect":"off","kb_start_fit":"100","kb_end_fit":"100","bg_end_position":"center top","kb_duration":"9000","kb_easing":"Linear.easeNone"}',
					
					'layers' => 
						'[]'
				);

				// Loop through data and add to DB 
				// --------------------------------------------------
				$slide_order = 1;
				foreach ($slides as $slide) {
					$rows_affected = $wpdb->insert( $wpdb->prefix.'revslider_slides', 
						array(
							'slider_id' => $sliderID,
							'slide_order' => $slide_order,
							'params' => $slide['params'],
							'layers' => $slide['layers']
						)
					);
					$slide_order++;
				}

			}
										

			// Mark the database showing this has been done
			// --------------------------------------------------
			$rev_slider['slides'] = $slides;
			update_option( "slider_".$rev_slider["alias"], $rev_slider );
		
		} // if $slider_rows (slide show added)

	} // if !get_option( [theme]_[slider-alias] ) && !get_option( "slider_[slider-alias] )


	#================================================================================================================


	// ==================================================
	// Add Another Slide Show
	// ==================================================
	$rev_slider = array();
	$rev_slider["title"]  = 'Wedding';
	$rev_slider["alias"]  = 'wedding';
	$rev_slider["params"] = '{"title":"Wedding","alias":"wedding","shortcode":"[rev_slider wedding]","source_type":"gallery","post_types":"post","post_category":"category_5","post_sortby":"ID","posts_sort_direction":"DESC","max_slider_posts":"30","excerpt_limit":"55","slider_template_id":"","posts_list":"","slider_type":"fullscreen","fullscreen_offset_container":"","fullscreen_min_height":"","full_screen_align_force":"on","auto_height":"off","force_full_width":"off","width":"960","height":"350","responsitive_w1":"940","responsitive_sw1":"770","responsitive_w2":"780","responsitive_sw2":"500","responsitive_w3":"510","responsitive_sw3":"310","responsitive_w4":"0","responsitive_sw4":"0","responsitive_w5":"0","responsitive_sw5":"0","responsitive_w6":"0","responsitive_sw6":"0","delay":"9000","shuffle":"off","lazy_load":"off","use_wpml":"off","stop_slider":"off","stop_after_loops":0,"stop_at_slide":2,"load_googlefont":"false","google_font":"","position":"center","margin_top":0,"margin_bottom":0,"margin_left":0,"margin_right":0,"shadow_type":"0","show_timerbar":"hide","padding":0,"background_color":"#2b2b2b","background_dotted_overlay":"none","show_background_image":"false","background_image":"","bg_fit":"cover","bg_repeat":"no-repeat","bg_position":"center top","touchenabled":"on","stop_on_hover":"on","navigaion_type":"none","navigation_arrows":"none","navigation_style":"round","navigaion_always_on":"false","hide_thumbs":200,"navigaion_align_hor":"center","navigaion_align_vert":"bottom","navigaion_offset_hor":"0","navigaion_offset_vert":20,"leftarrow_align_hor":"left","leftarrow_align_vert":"center","leftarrow_offset_hor":20,"leftarrow_offset_vert":0,"rightarrow_align_hor":"right","rightarrow_align_vert":"center","rightarrow_offset_hor":20,"rightarrow_offset_vert":0,"thumb_width":100,"thumb_height":50,"thumb_amount":5,"hide_slider_under":0,"hide_defined_layers_under":0,"hide_all_layers_under":0,"hide_thumbs_under_resolution":0,"start_with_slide":"1","first_transition_type":"fade","first_transition_duration":300,"first_transition_slot_amount":7,"reset_transitions":"","reset_transition_duration":0,"0":"Execute settings on all slides","jquery_noconflict":"on","js_to_body":"false","output_type":"none","template":"false"}';
	
	if( !get_option( $shortname.$rev_slider["alias"] ) && !get_option( "slider_".$rev_slider["alias"] ) ) {

		$slider_rows = $wpdb->insert( $wpdb->prefix.'revslider_sliders', 
			array(
				'title' => $rev_slider["title"],
				'alias' => $rev_slider["alias"],
				'params' => $rev_slider["params"]
			)
		);


		if ($slider_rows) {

			// Get the new ID
			$sql = 'SELECT id FROM '. $wpdb->prefix .'revslider_sliders WHERE alias = "'. $rev_slider["alias"] .'" ;';
			$newSlider = $wpdb->get_results($sql);
			$sliderID = $newSlider[0]->id;


			// Add default Slides to Slide Show
			// --------------------------------------------------
			if ($sliderID) {

				$slides = array();

				// Slide 1
				$slides[] = array(
					'params' => 
						'{"background_type":"image","image":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/wedding-bg.jpg","image_id":"5027","title":"Slide","state":"published","date_from":"","date_to":"","slide_transition":"boxfade","0":"Choose Image","slot_amount":7,"transition_rotation":0,"transition_duration":1200,"delay":"","enable_link":"false","link_type":"regular","link":"","link_open_in":"same","slide_link":"nothing","link_pos":"front","slide_thumb":"","slide_bg_color":"#E7E7E7","slide_bg_external":"","bg_fit":"cover","bg_fit_x":"100","bg_fit_y":"100","bg_repeat":"no-repeat","bg_position":"center center","bg_position_x":"0","bg_position_y":"0","kenburn_effect":"off","kb_start_fit":"100","kb_end_fit":"100","bg_end_position":"center top","kb_duration":"9000","kb_easing":"Linear.easeNone","0":"Choose Image"}',
					
					'layers' => 
						'[{"style":"","text":"Insignia","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/wedding-insignia.png","left":-55,"top":25,"animation":"sfb","easing":"Power2.easeInOut","speed":1600,"align_hor":"center","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":1200,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":660,"height":441,"serial":"0","endTimeFinal":7400,"endSpeedFinal":300,"realEndTime":9000,"timeLast":7800,"alt":"","scaleX":"660","scaleY":"441","scaleProportional":true,"attrID":"","attrClasses":"visible-desktop","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""},{"style":"","text":"Insignia (mobile)","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/wedding-insignia.png","left":0,"top":0,"animation":"sfb","easing":"Power2.easeInOut","speed":1200,"align_hor":"center","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":1200,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":600,"height":401,"serial":"1","endTimeFinal":7800,"endSpeedFinal":300,"realEndTime":9000,"timeLast":7800,"alt":"","scaleX":"600","scaleY":"401","scaleProportional":true,"attrID":"","attrClasses":"hidden-desktop","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""}]'
				);

				// Loop through data and add to DB 
				// --------------------------------------------------
				$slide_order = 1;
				foreach ($slides as $slide) {
					$rows_affected = $wpdb->insert( $wpdb->prefix.'revslider_slides', 
						array(
							'slider_id' => $sliderID,
							'slide_order' => $slide_order,
							'params' => $slide['params'],
							'layers' => $slide['layers']
						)
					);
					$slide_order++;
				}

			}
										

			// Mark the database showing this has been done
			// --------------------------------------------------
			$rev_slider['slides'] = $slides;
			update_option( "slider_".$rev_slider["alias"], $rev_slider );
		
		} // if $slider_rows (slide show added)

	} // if !get_option( [theme]_[slider-alias] ) && !get_option( "slider_[slider-alias] )


	#================================================================================================================


	// ==================================================
	// Add Another Slide Show
	// ==================================================
	$rev_slider = array();
	$rev_slider["title"]  = 'Shop';
	$rev_slider["alias"]  = 'shop';
	$rev_slider["params"] = '{"title":"Shop","alias":"shop","shortcode":"[rev_slider shop]","source_type":"gallery","post_types":"post","post_category":"category_5","post_sortby":"ID","posts_sort_direction":"DESC","max_slider_posts":"30","excerpt_limit":"55","slider_template_id":"","posts_list":"","slider_type":"fullwidth","fullscreen_offset_container":"","fullscreen_min_height":"","full_screen_align_force":"off","auto_height":"off","force_full_width":"off","width":"1200","height":"563","responsitive_w1":"940","responsitive_sw1":"770","responsitive_w2":"780","responsitive_sw2":"500","responsitive_w3":"510","responsitive_sw3":"310","responsitive_w4":"0","responsitive_sw4":"0","responsitive_w5":"0","responsitive_sw5":"0","responsitive_w6":"0","responsitive_sw6":"0","delay":"4500","shuffle":"off","lazy_load":"off","use_wpml":"off","stop_slider":"off","stop_after_loops":0,"stop_at_slide":2,"load_googlefont":"false","google_font":"","position":"center","margin_top":0,"margin_bottom":0,"margin_left":0,"margin_right":0,"shadow_type":"0","show_timerbar":"hide","padding":0,"background_color":"#fff","background_dotted_overlay":"none","show_background_image":"true","background_image":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/shop-slideshow-bg.jpg","bg_fit":"cover","bg_repeat":"no-repeat","bg_position":"center center","touchenabled":"on","stop_on_hover":"on","navigaion_type":"bullet","navigation_arrows":"solo","navigation_style":"round","navigaion_always_on":"false","hide_thumbs":200,"navigaion_align_hor":"center","navigaion_align_vert":"bottom","navigaion_offset_hor":"0","navigaion_offset_vert":20,"leftarrow_align_hor":"left","leftarrow_align_vert":"center","leftarrow_offset_hor":20,"leftarrow_offset_vert":0,"rightarrow_align_hor":"right","rightarrow_align_vert":"center","rightarrow_offset_hor":20,"rightarrow_offset_vert":0,"thumb_width":100,"thumb_height":50,"thumb_amount":5,"hide_slider_under":0,"hide_defined_layers_under":0,"hide_all_layers_under":0,"hide_thumbs_under_resolution":0,"start_with_slide":"1","first_transition_type":"fade","first_transition_duration":300,"first_transition_slot_amount":7,"reset_transitions":"","reset_transition_duration":0,"0":"Execute settings on all slides","jquery_noconflict":"on","js_to_body":"false","output_type":"none","template":"false"}';
	
	if( !get_option( $shortname.$rev_slider["alias"] ) && !get_option( "slider_".$rev_slider["alias"] ) ) {

		$slider_rows = $wpdb->insert( $wpdb->prefix.'revslider_sliders', 
			array(
				'title' => $rev_slider["title"],
				'alias' => $rev_slider["alias"],
				'params' => $rev_slider["params"]
			)
		);


		if ($slider_rows) {

			// Get the new ID
			$sql = 'SELECT id FROM '. $wpdb->prefix .'revslider_sliders WHERE alias = "'. $rev_slider["alias"] .'" ;';
			$newSlider = $wpdb->get_results($sql);
			$sliderID = $newSlider[0]->id;


			// Add default Slides to Slide Show
			// --------------------------------------------------
			if ($sliderID) {

				$slides = array();

				// Slide 1
				$slides[] = array(
					'params' => 
						'{"background_type":"trans","image":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/shop-slideshow-bg.jpg","image_id":"5150","title":"Slide","state":"published","date_from":"","date_to":"","slide_transition":"random","0":"Choose Image","slot_amount":7,"transition_rotation":0,"transition_duration":300,"delay":"","enable_link":"false","link_type":"regular","link":"","link_open_in":"same","slide_link":"nothing","link_pos":"front","slide_thumb":"","slide_bg_color":"#E7E7E7","slide_bg_external":"","bg_fit":"cover","bg_fit_x":"100","bg_fit_y":"100","bg_repeat":"no-repeat","bg_position":"center top","bg_position_x":"0","bg_position_y":"0","kenburn_effect":"off","kb_start_fit":"100","kb_end_fit":"100","bg_end_position":"center top","kb_duration":"9000","kb_easing":"Linear.easeNone","0":"Choose Image"}',
					
					'layers' => 
						'[{"style":"","text":"Image 1","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/shop-slideshow-scarf.png","left":80,"top":0,"animation":"sfl","easing":"Power2.easeInOut","speed":600,"align_hor":"left","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":600,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":441,"height":490,"serial":"0","endTimeFinal":8400,"endSpeedFinal":300,"realEndTime":9000,"timeLast":8400,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""},{"style":"","text":"Image 2","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/shop-slideshow-info.png","left":140,"top":0,"animation":"sfl","easing":"Power2.easeInOut","speed":600,"align_hor":"right","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":900,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":456,"height":168,"serial":"1","endTimeFinal":8400,"endSpeedFinal":300,"realEndTime":9000,"timeLast":8100,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""}]'
				);

				// Slide 2
				$slides[] = array(
					'params' => 
						'{"background_type":"trans","image":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/shop-slideshow-bg.jpg","image_id":"5150","title":"Slide","state":"published","date_from":"","date_to":"","slide_transition":"random","0":"Choose Image","slot_amount":7,"transition_rotation":0,"transition_duration":300,"delay":"","enable_link":"false","link_type":"regular","link":"","link_open_in":"same","slide_link":"nothing","link_pos":"front","slide_thumb":"","slide_bg_color":"#E7E7E7","slide_bg_external":"","bg_fit":"cover","bg_fit_x":"100","bg_fit_y":"100","bg_repeat":"no-repeat","bg_position":"center top","bg_position_x":"0","bg_position_y":"0","kenburn_effect":"off","kb_start_fit":"100","kb_end_fit":"100","bg_end_position":"center top","kb_duration":"9000","kb_easing":"Linear.easeNone","0":"Choose Image"}',
					
					'layers' => 
						'[{"style":"","text":"Image 1","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/shop-slideshow-bag.png","left":80,"top":0,"animation":"sfl","easing":"Power2.easeInOut","speed":600,"align_hor":"left","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":600,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":441,"height":490,"serial":"0","endTimeFinal":8400,"endSpeedFinal":300,"realEndTime":9000,"timeLast":8400,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""},{"style":"","text":"Image 2","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/shop-slideshow-info.png","left":140,"top":0,"animation":"sfr","easing":"Power2.easeInOut","speed":600,"align_hor":"right","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":900,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":456,"height":168,"serial":"1","endTimeFinal":8400,"endSpeedFinal":300,"realEndTime":9000,"timeLast":8100,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""}]'
				);

				// Slide 3
				$slides[] = array(
					'params' => 
						'{"background_type":"trans","image":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/shop-slideshow-bg.jpg","image_id":"5150","title":"Slide","state":"published","date_from":"","date_to":"","slide_transition":"random","0":"Choose Image","slot_amount":7,"transition_rotation":0,"transition_duration":300,"delay":"","enable_link":"false","link_type":"regular","link":"","link_open_in":"same","slide_link":"nothing","link_pos":"front","slide_thumb":"","slide_bg_color":"#E7E7E7","slide_bg_external":"","bg_fit":"cover","bg_fit_x":"100","bg_fit_y":"100","bg_repeat":"no-repeat","bg_position":"center top","bg_position_x":"0","bg_position_y":"0","kenburn_effect":"off","kb_start_fit":"100","kb_end_fit":"100","bg_end_position":"center top","kb_duration":"9000","kb_easing":"Linear.easeNone","0":"Choose Image"}',
					
					'layers' => 
						'[{"style":"","text":"Image 1","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/shop-slideshow-belt.png","left":80,"top":0,"animation":"sfr","easing":"Power2.easeInOut","speed":600,"align_hor":"left","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":600,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":441,"height":490,"serial":"0","endTimeFinal":8400,"endSpeedFinal":300,"realEndTime":9000,"timeLast":8400,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""},{"style":"","text":"Image 2","type":"image","image_url":"http:\/\/para.llel.us\/themes\/vellum-wp\/wp-content\/uploads\/2014\/02\/shop-slideshow-info.png","left":140,"top":0,"animation":"sfr","easing":"Power2.easeInOut","speed":600,"align_hor":"right","align_vert":"middle","hiddenunder":false,"resizeme":true,"link":"","link_open_in":"same","link_slide":"nothing","scrollunder_offset":"","time":900,"endtime":"","endspeed":300,"endanimation":"auto","endeasing":"nothing","corner_left":"nothing","corner_right":"nothing","width":456,"height":168,"serial":"1","endTimeFinal":8400,"endSpeedFinal":300,"realEndTime":9000,"timeLast":8100,"alt":"","scaleX":"","scaleY":"","scaleProportional":false,"attrID":"","attrClasses":"","attrTitle":"","attrRel":"","link_id":"","link_class":"","link_title":"","link_rel":""}]'
				);

				// Loop through data and add to DB 
				// --------------------------------------------------
				$slide_order = 1;
				foreach ($slides as $slide) {
					$rows_affected = $wpdb->insert( $wpdb->prefix.'revslider_slides', 
						array(
							'slider_id' => $sliderID,
							'slide_order' => $slide_order,
							'params' => $slide['params'],
							'layers' => $slide['layers']
						)
					);
					$slide_order++;
				}

			}
										

			// Mark the database showing this has been done
			// --------------------------------------------------
			$rev_slider['slides'] = $slides;
			update_option( "slider_".$rev_slider["alias"], $rev_slider );
		
		} // if $slider_rows (slide show added)

	} // if !get_option( [theme]_[slider-alias] ) && !get_option( "slider_[slider-alias] )


	#================================================================================================================


	// ==================================================
	// Mark the database showing ALL demo sliders imported for THIS theme
	// ==================================================

	$rev_slider['slides'] = $slides;
	update_option( $shortname.'demo_slider', $rev_slider ); // Theme Specific Setting

}

# --------------------------------------------------
# Add action for data import
# --------------------------------------------------

// Update database if row doesn't exist
if( !get_option( $shortname.'demo_slider' ) ) {

	// Call the demo data function after theme setup (admin only)
	add_action( 'after_setup_theme', 'importDemoSlider' );

}


?>