#!/bin/bash
# JRM_OUT=$HOME/.irssi/config
JRM_OUT=$HOME/.irssi/config
 
echo "jeromatic irssi configuration creator v0.4.20"
sleep 1s
echo "this will create a config file for irssi, with your username and a server, setup and ready to go."
sleep 1s
echo "=====[SERVER CONFIG]====="
echo "enter the server you would like to configure"
echo "no quotes or prefixes. example: irc.myserver.com"
read JRM_SRV_URL
echo "setting up server..."

sleep 1s
echo "done."
sleep 1s
echo "enter a friendly name to call this server."
echo "example: myserver"
read JRM_SRV_NAME
sleep 1s
echo "what port would you like to connect through?"
echo "leave blank for default port 6667"
read JRM_SRV_PORT
sleep 1s
echo "configuring server friendly name and port..."
sleep 1s
echo "Enter preferred username:"
read JRM_IRC_NAME
sleep 1s
echo "Enter preferred realname:"
read JRM_REAL_NAME
sleep 1s
echo "Enter the chat room you would like to automatically join upon connecting to the server."
echo "do not use the [#]hashtag. example: My_room"
read JRM_IRC_ROOM
sleep 1s
echo "configuring..."

if [[ -z $JRM_SRV_PORT ]]; then
    JRM_SRV_PORT=6667
fi 

cat <<EOF >$JRM_OUT
servers = (

  {
    address = "$JRM_SRV_URL";
    chatnet = "$JRM_SRV_NAME";
    port = "$JRM_SRV_PORT";
    use_tls = "no";
    tls_verify = "no";
    autoconnect = "yes";
  }
);
EOF

echo "Setup auto-login (with e.g. NickServ)? (Y/n)"
read JRM_NICK_YN
if [ "$JRM_NICK_YN" != "${JRM_NICK_YN#[Yy]}" ] ;then
      echo "Adding a generic autocmd to the config."
      sleep 1s
      echo "Enter the password to send to NickServ."
      read JRM_NICK_PW
      sleep 1s
      echo "Final format: /msg nickserv identify USERNAME PASSWORD"
      echo "You may need to tweak this in the raw config." 
      sleep 2s

      cat <<EOF >>$JRM_OUT
chatnets = {
  $JRM_SRV_NAME = { type = "IRC"; nick = "$JRM_IRC_NAME"; realname = "$JRM_REAL_NAME"; autosendcmd = "/^msg nickserv identify $JRM_IRC_NAME $JRM_NICK_PW; wait 2000"; };
};
EOF

    else
      echo "Skipping botserv auto commands..."
      cat <<EOF >>$JRM_OUT
 chatnets = {
  $JRM_SRV_NAME = { type = "IRC"; nick = "$JRM_IRC_NAME"; realname = "$JRM_REAL_NAME"; };
};  
EOF
      sleep 1s
fi

cat <<EOF >>$JRM_OUT

channels = ( { name = "$JRM_IRC_ROOM"; chatnet = "$JRM_SRV_NAME"; autojoin = "yes"; } );

settings = {
  core = {
    real_name = "$JRM_REAL_NAME";
    user_name = "$USER";
    nick = "$JRM_IRC_NAME";
  };
  "fe-text" = { actlist_sort = "refnum"; colors_ansi_24bit = "yes"; };
  "fe-common/core" = { 
    theme = "default";
    use_status_window = "yes";
    window_auto_change = "yes";
  };
  "perl/core/scripts" = {
    theme_autocolor = "yes";
    dau_statusbar_daumode_hide_when_off = "yes";
    neat_colorize = "yes";
    dau_daumode_channels = "$JRM_IRC_ROOM";
  };
};


EOF

sleep 1s
echo "filling in remaining config options with sane defaults..."

cat >> $JRM_OUT <<'EOF' 
aliases = {
  ATAG = "WINDOW SERVER";
  ADDALLCHANS = "SCRIPT EXEC foreach my \\$channel (Irssi::channels()) { Irssi::command(\"CHANNEL ADD -auto \\$channel->{name} \\$channel->{server}->{tag} \\$channel->{key}\")\\;}";
  B = "BAN";
  BACK = "AWAY";
  BANS = "BAN";
  BYE = "QUIT";
  C = "CLEAR";
  CALC = "EXEC - if command -v bc >/dev/null 2>&1\\; then printf '%s=' '$*'\\; echo '$*' | bc -l\\; else echo bc was not found\\; fi";
  CHAT = "DCC CHAT";
  DATE = "TIME";
  DEHIGHLIGHT = "DEHILIGHT";
  DESCRIBE = "ACTION";
  DHL = "DEHILIGHT";
  EXEMPTLIST = "MODE $C +e";
  EXIT = "QUIT";
  GOTO = "SCROLLBACK GOTO";
  HIGHLIGHT = "HILIGHT";
  HL = "HILIGHT";
  HOST = "USERHOST";
  INVITELIST = "MODE $C +I";
  J = "JOIN";
  K = "KICK";
  KB = "KICKBAN";
  KN = "KNOCKOUT";
  LAST = "LASTLOG";
  LEAVE = "PART";
  M = "MSG";
  MUB = "UNBAN *";
  N = "NAMES";
  NMSG = "^MSG";
  P = "PART";
  Q = "QUERY";
  RESET = "SET -default";
  RUN = "SCRIPT LOAD";
  SAY = "MSG *";
  SB = "SCROLLBACK";
  SBAR = "STATUSBAR";
  SIGNOFF = "QUIT";
  SV = "MSG * Irssi $J ($V) - https://irssi.org";
  T = "TOPIC";
  UB = "UNBAN";
  UMODE = "MODE $N";
  UNSET = "SET -clear";
  W = "WHO";
  WC = "WINDOW CLOSE";
  WG = "WINDOW GOTO";
  WJOIN = "JOIN -window";
  WI = "WHOIS";
  WII = "WHOIS $0 $0";
  WL = "WINDOW LIST";
  WN = "WINDOW NEW HIDDEN";
  WQUERY = "QUERY -window";
  WW = "WHOWAS";
};

statusbar = {

  items = {

    barstart = "{sbstart}";
    barend = "{sbend}";

    topicbarstart = "{topicsbstart}";
    topicbarend = "{topicsbend}";

    time = "{sb $Z}";
    user = "{sb {sbnickmode $cumode}$N{sbmode $usermode}{sbaway $A}}";

    window = "{sb $winref:$tag/$itemname{sbmode $M}}";
    window_empty = "{sb $winref{sbservertag $tag}}";

    prompt = "{prompt $[.15]itemname}";
    prompt_empty = "{prompt $winname}";

    topic = " $topic";
    topic_empty = " Irssi v$J - https://irssi.org";

    lag = "{sb Lag: $0-}";
    act = "{sb Act: $0-}";
    more = "-- more --";
  };

  default = {

    window = {

      disabled = "no";
      type = "window";
      placement = "bottom";
      position = "1";
      visible = "active";

      items = {
        barstart = { priority = "100"; };
        time = { };
        user = { };
        window = { };
        window_empty = { };
        lag = { priority = "-1"; };
        act = { priority = "10"; };
        more = { priority = "-1"; alignment = "right"; };
        barend = { priority = "100"; alignment = "right"; };
        loadavg = { };
        daumode = { };
      };
    };

    window_inact = {

      type = "window";
      placement = "bottom";
      position = "1";
      visible = "inactive";

      items = {
        barstart = { priority = "100"; };
        window = { };
        window_empty = { };
        more = { priority = "-1"; alignment = "right"; };
        barend = { priority = "100"; alignment = "right"; };
      };
    };

    prompt = {

      type = "root";
      placement = "bottom";
      position = "100";
      visible = "always";

      items = {
        prompt = { priority = "-1"; };
        prompt_empty = { priority = "-1"; };
        input = { priority = "10"; };
      };
    };

    topic = {

      type = "root";
      placement = "top";
      position = "1";
      visible = "always";

      items = {
        topicbarstart = { priority = "100"; };
        topic = { };
        topic_empty = { };
        topicbarend = { priority = "100"; alignment = "right"; };
      };
    };
  };
};
keyboard = (
  { key = "meta-[M"; id = "command"; data = "mouse_xterm "; }
);

EOF


echo "done..."
sleep 1s
echo "you may now run irssi. upon starting you will be taken to the main server window."
echo "to switch to your auto-joined chat room, press [Alt+2]". 
sleep 1s
exit 
 

