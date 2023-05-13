package main

import (
	"net"
	"sync"
)

// Connections contains all connections
type Connections struct {
	conns map[string]*net.TCPConn
	sync.RWMutex
}

func (c *Connections) New(key string, conn *net.TCPConn) bool {
	c.Lock()
	defer c.Unlock()

	if _, ok := c.conns[key]; !ok {
		c.conns[key] = conn
		return true
	}
	return false
}

//func (c *Connections) Delete(key string) bool {
//	c.Lock()
//	defer c.Unlock()
//
//	if _, ok := c.conns[key]; ok {
//		delete(c.conns, key)
//		return true
//	}
//	return false
//}
//
//func (c *Connections) Read(key string) *net.TCPConn {
//	c.RLock()
//	defer c.RUnlock()
//
//	if conn, ok := c.conns[key]; ok {
//		return conn
//	}
//
//	return nil
//}

//func (c *Connections) broadcast(messages chan *MSG) { // по идее такой броадкастер мне надо создать в каждой игре отдельноооо
//	//Loop continually sending messages
//	for {
//		msg := <-messages
//		//If user left, remove from conn pool
//		if msg.isLast {
//			c.Delete(msg.conn.RemoteAddr().String())
//			continue
//		}
//
//		for _, conn := range c.conns {
//			// не отправляем сообщение самому себе
//			if msg.conn != conn {
//				_, err := conn.Write([]byte(msg.msg))
//				if err != nil {
//					c.Delete(msg.conn.RemoteAddr().String())
//				}
//			}
//		}
//	}
//}
