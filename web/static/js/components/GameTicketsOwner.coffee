React = require 'react'
Reflux = require 'reflux'

Store = require '../stores/SocketConnectionStore'
Actions = Store.Actions

GameNewTicketOwner = require './GameNewTicketOwner'

GameTickets = React.createClass
  mixins: [
    Reflux.connect(Store)
  ]

  onDeleteTicket: (e) ->
    Actions.deleteTicket(e.target.dataset.id)
    e.preventDefault()

  render: ->
    <table className="tickets-list full-width">
      <caption>
        <span>
          Tickets list&nbsp;
        </span>
        <span className="counter">
          ({ @state.game.tickets.length } total)
        </span>
      </caption>
      <tbody>
        { for ticket in @state.game.tickets
          <tr key={ticket.id}>
            <td>
              <form>
                <table className="full-width">
                  <tr>
                    <td className="index-column">
                      { ticket.id }
                    </td>
                    <td className="name-column">
                      <input className="full-width" type="text" value={ ticket.name }/>
                    </td>
                    <td className="estimation-column">
                      { ticket.points }
                    </td>
                    <td className="delete-column">
                      <input type="button" data-id={ticket.id} value="DELETE" onClick={ @onDeleteTicket }/>
                    </td>
                  </tr>
                </table>
              </form>
            </td>
          </tr>
        }
        <GameNewTicketOwner/>
      </tbody>
    </table>

module.exports = GameTickets
