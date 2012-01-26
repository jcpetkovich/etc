------------------------------------------------------------------------
-- JC's Config File:
--

import XMonad
import System.Exit (ExitCode (ExitSuccess), exitWith)
import System.IO (hPutStrLn)
import XMonad.Actions.UpdatePointer (PointerPosition (Relative), updatePointer)
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.DynamicLog (PP(..), defaultPP, dynamicLogWithPP, dzenPP, ppOutput, ppCurrent, wrap, ppTitle, ppLayout, ppHidden)
import XMonad.Hooks.ManageDocks (ToggleStruts (ToggleStruts), avoidStruts)
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.Layout.NoBorders (noBorders)
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig (additionalKeys, additionalKeysP)

import qualified Data.Map as M
import Control.Arrow ((&&&))
import Data.Char (toLower)

------------------------------------------------------------------------
-- Commands
--
dmenuCommand = "dmenu_run -nb '#242424' -nf '#D8BFD8'"

dzenCommand = readFile "etc/dzen/dzencommand"

emacsCommand = "emacsclient -c ~/org/whiteboard.org || (emacs --daemon && emacsclient -c ~/org/whiteboard.org)"

starcraft = "wine ~/.wine/drive_c/Program\\ Files/StarCraft/StarCraft.exe"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
mergeKeys c k = c `additionalKeysP` k c
jckeys c = [ ("M-<Return>", spawn $ terminal c)   -- launch terminal
           , ("M-v", windows W.swapMaster)        -- swap current and master
           , ("M-p", spawn dmenuCommand)          -- launch dmenu
           , ("M-b", sendMessage ToggleStruts)    -- Toggle Struts
           , ("M-f", spawn "firefox")             -- launch firefox
           , ("M-e", spawn emacsCommand)          -- launch emacs
           , ("M-S-s", spawn starcraft)           -- launch SC:BW
           , ("M-c", kill)                        -- close window
           , ("M-S-l", spawn "slock")             -- lock
           , ("M-8", spawn "mpc toggle")          -- pause/play
           , ("M-7", spawn "mpc prev")            -- previous song
           , ("M-0", spawn "mpc next")            -- next song
           , ("M--", spawn "mpc volume -5")       -- volume - 5
           , ("M-=", spawn "mpc volume +5")       -- volume + 5
           , ("M-S-z", io (exitWith ExitSuccess)) -- exit xmonad
           ]


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
       -- Screen related keys
       --
       , keys = \c -> M.fromList [((m .|. modMask c, key), screenWorkspace sc >>= flip whenJust (windows . f))
                                  | (key, sc) <- zip [xK_q, xK_w, xK_d] [0..]
                                 , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
                `M.union` keys defaultConfig c 

       -----------------------------------------------------------------
       -- Workspaces:
       --
       , workspaces         = ["term","web","emacs","doc","vid","misc"] 
                              
       -----------------------------------------------------------------
       -- Hooks:
       --
       , startupHook        = startupHook defaultConfig >> setWMName "LG3D"
       , layoutHook         = avoidStruts jcLayoutHook

       , logHook            = do 
         ws <- gets windowset
         let sl = if null $ W.visible ws then [] else W.screens ws
         let m = map ((W.tag . W.workspace) &&& W.screen) sl
         updatePointer (Relative 0.99 0.99) << dynamicLogWithPP defaultPP
                              { ppCurrent = myPPCurrent m
                              , ppVisible = myPPVisible m
                              , ppHidden = myPPHidden
                              , ppHiddenNoWindows = myPPHidden . (++ "-empty")
                              , ppUrgent = const ""
                              , ppSep = ""
                              , ppWsSep = ""
                              , ppTitle = const ""
                              , ppLayout = myPPLayout
                              , ppOrder = id
                              , ppOutput = hPutStrLn xmproc
                              }
       
       -- Rules for applications:
       , manageHook         = manageHook defaultConfig <+> myManageHook
       } `mergeKeys` jckeys 

       where
         myManageHook = composeAll 
                        [ className =? "MPlayer"            --> doFloat
                        , className =? "Gimp"               --> doFloat
                        , className =? "KMenu"              --> doFloat
                        , className =? "Amarok"             --> doFloat
                        , title =? "Brood War"              --> doIgnore
                        , className =? "trayer"             --> doIgnore
                        , className =? "feh"                --> doFloat
                        , className =? "Firefox"            --> doF(W.shift "web")
                        , className =? "OpenOffice.org 3.0" --> doF(W.shift "doc")
                        , className =? "Pidgin"             --> doF(W.shift "term")
                        , isFullscreen --> doFullFloat ]

         myPPCurrent m t = activeWorkspace t ++ iconScreen (lookup t m)
         myPPVisible m t = inactiveWorkspace t ++ iconScreen (lookup t m)
         myPPHidden = (++ screenPad) . inactiveWorkspace
         myPPLayout = wrap "-^p(+6)" "^p(+7)" . iconLayout


iconWrap :: String -> String
iconWrap = wrap "^i(/home/jcp/etc/dzen/pixmaps/" ".xpm)"

bracketPad :: String
bracketPad = "^p(+4)"

screenPad :: String
screenPad = "^p(+4)"

activeWorkspace :: String -> String
activeWorkspace = wrap lb rb . iconWrap
  where lb = iconWrap "left-bracket"
        rb = iconWrap "right-bracket"

inactiveWorkspace :: String -> String
inactiveWorkspace = wrap bracketPad bracketPad . iconWrap

iconLayout :: String -> String
iconLayout = iconWrap . ("layout-" ++) . map ((\c -> if c == ' ' then '-' else c) . toLower)

iconScreen :: Maybe ScreenId -> String
iconScreen Nothing = "^p(+4)"
iconScreen (Just (S s)) = iconWrap $ ("screen-" ++) . show $ s + 1

(<<) = flip (>>)
