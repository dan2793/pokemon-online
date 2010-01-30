#include "server.h"
#include "player.h"
#include "analyze.h"

Player::Player(int _id, QTcpSocket *s)
{
    m_relay = new Analyzer(s, id());
    m_relay->setParent(this);

    id() = _id;
    ip() = s->peerAddress().toString();

    connect(m_relay, SIGNAL(disconnected()), SLOT(disconnected()));
}

void Player::disconnected()
{
    emit disconnection(id());
}

void Player::kick()
{
    m_relay->close();
}

void Player::sendServer(const Server &s)
{
    m_relay->sendServer(s.name(), s.desc(), s.players(), s.ip());
}
