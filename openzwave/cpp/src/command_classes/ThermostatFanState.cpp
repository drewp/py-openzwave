//-----------------------------------------------------------------------------
//
//	ThermostatFanState.cpp
//
//	Implementation of the Z-Wave COMMAND_CLASS_THERMOSTAT_FAN_STATE
//
//	Copyright (c) 2010 Mal Lansell <openzwave@lansell.org>
//
//	SOFTWARE NOTICE AND LICENSE
//
//	This file is part of OpenZWave.
//
//	OpenZWave is free software: you can redistribute it and/or modify
//	it under the terms of the GNU Lesser General Public License as published
//	by the Free Software Foundation, either version 3 of the License,
//	or (at your option) any later version.
//
//	OpenZWave is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU Lesser General Public License for more details.
//
//	You should have received a copy of the GNU Lesser General Public License
//	along with OpenZWave.  If not, see <http://www.gnu.org/licenses/>.
//
//-----------------------------------------------------------------------------

#include "CommandClasses.h"
#include "ThermostatFanState.h"
#include "Defs.h"
#include "Msg.h"
#include "Node.h"
#include "Driver.h"
#include "Log.h"

#include "ValueString.h"

using namespace OpenZWave;

enum ThermostatFanStateCmd
{
	ThermostatFanStateCmd_Get				= 0x02,
	ThermostatFanStateCmd_Report			= 0x03
};

static char const* c_stateName[] = 
{
	"Idle",
	"Running",
	"Running High",
	"State 03",			// Undefined states.  May be used in the future.
	"State 04",
	"State 05",
	"State 06",
	"State 07",
	"State 08",
	"State 09",
	"State 10",
	"State 11",
	"State 12",
	"State 13",
	"State 14",
	"State 15"
};

//-----------------------------------------------------------------------------
// <ThermostatFanState::RequestState>
// Get the static thermostat mode details from the device
//-----------------------------------------------------------------------------
bool ThermostatFanState::RequestState
(
	uint32 const _requestFlags
)
{
	if( _requestFlags & RequestFlag_Dynamic )
	{
		// Request the current state
		RequestValue();
		return true;
	}
	return false;
}

//-----------------------------------------------------------------------------
// <ThermostatFanState::RequestValue>
// Get the thermostat fan state details from the device
//-----------------------------------------------------------------------------
void ThermostatFanState::RequestValue
(
	uint8 const _dummy1,	// = 0 (not used)
	uint8 const _dummy2		// = 0 (not used)
)
{
	// Request the current state
	Msg* msg = new Msg( "Request Current Thermostat Fan State", GetNodeId(), REQUEST, FUNC_ID_ZW_SEND_DATA, true, true, FUNC_ID_APPLICATION_COMMAND_HANDLER, GetCommandClassId() );
	msg->Append( GetNodeId() );
	msg->Append( 2 );
	msg->Append( GetCommandClassId() );
	msg->Append( ThermostatFanStateCmd_Get );
	msg->Append( TRANSMIT_OPTION_ACK | TRANSMIT_OPTION_AUTO_ROUTE );
	GetDriver()->SendMsg( msg );
}

//-----------------------------------------------------------------------------
// <ThermostatFanState::HandleMsg>
// Handle a message from the Z-Wave network
//-----------------------------------------------------------------------------
bool ThermostatFanState::HandleMsg
(
	uint8 const* _data,
	uint32 const _length,
	uint32 const _instance	// = 1
)
{
	if( ThermostatFanStateCmd_Report == (ThermostatFanStateCmd)_data[0] )
	{
		// We have received the thermostat fan state from the Z-Wave device
		if( ValueString* valueString = static_cast<ValueString*>( GetValue( _instance, 0 ) ) )
		{
			valueString->OnValueChanged( c_stateName[_data[1]&0x0f] );
			Log::Write( "Received thermostat fan state from node %d: %s", GetNodeId(), valueString->GetValue().c_str() );		
		}
		return true;
	}
		
	return false;
}

//-----------------------------------------------------------------------------
// <ThermostatFanState::CreateVars>
// Create the values managed by this command class
//-----------------------------------------------------------------------------
void ThermostatFanState::CreateVars
(
	uint8 const _instance
)
{
	if( Node* node = GetNodeUnsafe() )
	{
		node->CreateValueString( ValueID::ValueGenre_User, GetCommandClassId(), _instance, 0, "Fan State", "", true, c_stateName[0] );
	}
}

