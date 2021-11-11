function send_msg(msg_in)
    tcpipClient = tcpip('127.0.0.1',55001,'NetworkRole','Client');
    set(tcpipClient,'Timeout',30);

    n= 0;
    while (n<2)
        n=n+1;
        fopen(tcpipClient);
        msg_unity=msg_in;
        fwrite(tcpipClient,msg_unity);
        fclose(tcpipClient);
        pause(0.01)
    end
