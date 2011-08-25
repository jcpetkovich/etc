------------------------------------------------------------------------
-- JC's Config File:
--

import XMonad
import System.Exit
import XMonad.Actions.UpdatePointer
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import System.IO

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import Data.List
import Control.Monad
import Data.Char
 
dmenuCommand = "exe=`dmenu_path | dmenu -nb '#242424' -nf '#D8BFD8'` && eval \"exec $exe\""

dzenCommand = readFile "/home/jcpetkovich/etc/dzen/dzencommand"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
jcKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [ -- applications
      ((modm, xK_Return          ), spawn $ XMonad.terminal conf                                               ) -- launch terminal
    , ((modm, xK_v               ), windows W.swapMaster                                                       ) -- swap current and master
    , ((modm, xK_p               ), spawn dmenuCommand                                                         ) -- launch krunner
    , ((modm, xK_b               ), sendMessage ToggleStruts                                                   ) -- Toggle Struts
    , ((modm, xK_f               ), spawn "firefox"                                                            ) -- launch firefox
    , ((modm, xK_e               ), spawn "emacsclient -c ~/org/whiteboard.org || (emacs --daemon && emacsclient -c ~/org/whiteboard.org)" ) -- launch emacs
    , ((modm .|. shiftMask, xK_s ), spawn "wine ~/.wine/drive_c/Program\\ Files/StarCraft/StarCraft.exe"       ) -- launch SC:BW
--    , ((modm, xK_d             ), spawn "konqueror --profile 'JC profile'"                                   ) -- launch konqueror
    , ((modm, xK_c               ), kill                                                                       ) -- close window
    , ((modm, xK_q               ), spawn "thunar"                                                             ) -- launch kde systemsettings
    , ((modm .|. shiftMask, xK_l ), spawn "slock"                                                              ) -- lock

    -- music
    -- , ((modm, xK_8            ), spawn "qdbus org.kde.amarok /Player org.freedesktop.MediaPlayer.PlayPause" ) -- pause/play
    -- , ((modm, xK_7            ), spawn "qdbus org.kde.amarok /Player org.freedesktop.MediaPlayer.Prev"      ) -- previous song
    -- , ((modm, xK_0            ), spawn "qdbus org.kde.amarok /Player org.freedesktop.MediaPlayer.Next"      ) -- next song
    , ((modm, xK_8               ), spawn "mpc toggle"                                                         ) -- pause/play
    , ((modm, xK_7               ), spawn "mpc prev"                                                           ) -- previous song
    , ((modm, xK_0               ), spawn "mpc next"                                                           ) -- next song
    , ((modm, xK_minus           ), spawn "mpc volume -5"                                                      ) -- volume - 5
    , ((modm, xK_equal           ), spawn "mpc volume +5"                                                      ) -- volume + 5
    ]

    ++
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_q, xK_d] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    
------------------------------------------------------------------------
-- Layout Hook:
--
jcLayoutHook = tiled ||| Mirror tiled ||| noBorders Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
 
     -- The default number of windows in the master pane
     nmaster = 1
 
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
 
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Main:
--
main = do
  xmproc <- spawnPipe =<< dzenCommand
  xmonad $ defaultConfig
       { 
       -----------------------------------------------------------------
       -- Some sensible defaults:
       --
         terminal           = "urxvt"
       , modMask            = mod4Mask
       , normalBorderColor  = "#dddddd"
       , focusedBorderColor = "#ff0000"

       -----------------------------------------------------------------
       -- Workspaces:
       --
       , workspaces         = ["term","net","emacs","docs","media","misc"] 
 
       -----------------------------------------------------------------
       -- Key Definitions moved elsewhere for cleanliness:
       --
       , keys               = \c -> jcKeys c `M.union` 
                              keys defaultConfig c 

       -----------------------------------------------------------------
       -- Hooks:
       --
       , startupHook        = startupHook defaultConfig >> setWMName "LG3D"
       , layoutHook         = avoidStruts $ jcLayoutHook
       , logHook            = dynamicLogWithPP dzenPP 
                              { 
                                ppOutput = hPutStrLn xmproc
                              , ppCurrent = wrap "^fg(white)^bg(#333333) " "^bg()^fg()"
                              , ppTitle = wrap "^fg(#9ACD32)^bg(#333333)" " ^bg()^fg()"
                              , ppLayout = wrap "^fg(#D8BFD8)^bg(#333333) : " " : ^bg()^fg()"
                              , ppHidden = wrap "^fg(#D8BFD8)^bg(#333333) " "^bg()^fg()"
                              --   ppCurrent = xmobarColor "white" "" 
                              --   -- . wrap "[" "]",
                              -- , ppTitle = xmobarColor "#9ACD32" "" 
                              } >> updatePointer Nearest

       -- Rules for applications:
       , manageHook         = manageHook defaultConfig <+> myManageHook
       }
       where
         myManageHook = composeAll 
                              [ className =? "MPlayer"            --> doFloat
                              , className =? "Gimp"               --> doFloat
                              , className =? "KMenu"              --> doFloat
                              , className =? "Amarok"             --> doFloat
                              , title =? "Brood War"              --> doIgnore
                              , className =? "trayer"              --> doIgnore
                              , className =? "feh"                --> doFloat
                              , className =? "Firefox"            --> doF(W.shift "net")
                              -- , className =? "Emacs"           --> doF(W.shift "emacs")
                              , className =? "OpenOffice.org 3.0" --> doF(W.shift "docs")
                              , className =? "Pidgin"             --> doF(W.shift "term")
                              -- , className =? "Evince"             --> doF(W.shift "docs")
                              , isFullscreen --> doFullFloat]


