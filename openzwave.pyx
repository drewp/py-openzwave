from cython.operator cimport dereference as deref

cdef extern from "<string>" namespace "std":
    cdef cppclass string:
        string()
        string(char *)
        char * c_str()

ctypedef unsigned int uint32
ctypedef unsigned char uint8

cdef extern from "Options.h" namespace "OpenZWave":
    cdef cppclass Options:
        bint Lock()

cdef extern from "Python.h":
    void PyEval_InitThreads()

cdef extern from "Options.h" namespace "OpenZWave::Options":
    Options* Create(string a, string b, string c)

cdef extern from *:
    ctypedef char* const_notification "OpenZWave::Notification const*"

cdef extern from "Notification.h" namespace "OpenZWave::Notification":

    cdef enum NotificationType:
        Type_ValueAdded = 0
        Type_ValueRemoved = 1
        Type_ValueChanged = 2
        Type_Group = 3
        Type_NodeNew = 4
        Type_NodeAdded = 5
        Type_NodeRemoved = 6
        Type_NodeProtocolInfo = 7
        Type_NodeNaming = 8
        Type_NodeEvent = 9
        Type_PollingDisabled = 10
        Type_PollingEnabled = 11
        Type_DriverReady = 12
        Type_DriverReset = 13
        Type_MsgComplete = 14
        Type_NodeQueriesComplete = 15
        Type_AwakeNodesQueried = 16
        Type_AllNodesQueried = 17

cdef extern from "ValueID.h" namespace "OpenZWave":

    cdef enum ValueGenre:
        ValueGenre_Basic = 0
        ValueGenre_User = 1
        ValueGenre_Config = 2
        ValueGenre_System = 3
        ValueGenre_Count = 4

    cdef enum ValueType:
        ValueType_Bool = 0
        ValueType_Byte = 1
        ValueType_Decimal = 2
        ValueType_Int = 3
        ValueType_List = 4
        ValueType_Schedule = 5
        ValueType_Short = 6
        ValueType_String = 7
        ValueType_Button = 8
        ValueType_Max = ValueType_Button

    cdef cppclass ValueID:
        uint32 GetHomeId()
        uint8 GetNodeId()
        ValueGenre GetGenre()
        uint8 GetCommandClassId()
        uint8 GetInstance()
        uint8 GetIndex()
        ValueType GetType()
        uint32 GetId()

cdef extern from "Notification.h" namespace "OpenZWave":

    cdef cppclass Notification:
        NotificationType GetType()
        uint32 GetHomeId()
        uint8 GetNodeId()
        ValueID& GetValueID()
        uint8 GetGroupIdx()
        uint8 GetEvent()
        uint8 GetByte()

ctypedef void (*pfnOnNotification_t)(const_notification _pNotification, void* _context )

cdef extern from "Manager.h" namespace "OpenZWave":

    cdef cppclass Manager:
        # // Configuration
        void WriteConfig(uint32 homeid)
        # Options* GetOptions()
        # // Drivers
        bint AddDriver(string serialport)
        bint RemoveDriver(string controllerPath)
        uint8 GetControllerNodeId(uint32 homeid)
        bint IsPrimaryController(uint32 homeid)
        bint IsStaticUpdateController(uint32 homeid)
        bint IsBridgeController(uint32 homeid)
        string GetLibraryVersion(uint32 homeid)
        string GetLibraryTypeName(uint32 homeid)
        # // Polling
        uint32 GetPollInterval()
        void SetPollInterval(uint8 seconds)
        bint EnablePoll(ValueID& valueId)
        bint DisablePoll(ValueID& valueId)
        bint isPolled(ValueID& valueId)
        # // Node Information
        bint RefreshNodeInfo(uint32 homeid, uint8 nodeid)
        void RequestNodeState(uint32 homeid, uint8 nodeid)
        bint IsNodeListeningDevice(uint32 homeid, uint8 nodeid)
        bint IsNodeRoutingDevice(uint32 homeid, uint8 nodeid)
        uint32 GetNodeMaxBaudRate(uint32 homeid, uint8 nodeid)
        uint8 GetNodeVersion(uint32 homeid, uint8 nodeid)
        uint8 GetNodeSecurity(uint32 homeid, uint8 nodeid)
        uint8 GetNodeBasic(uint32 homeid, uint8 nodeid)
        uint8 GetNodeGeneric(uint32 homeid, uint8 nodeid)
        uint8 GetNodeSpecific(uint32 homeid, uint8 nodeid)
        string GetNodeType(uint32 homeid, uint8 nodeid)
        # uint32 GetNodeNeighbors(uint32 homeid, uint8 nodeid, uint8** nodeNeighbors)
        string GetNodeManufacturerName(uint32 homeid, uint8 nodeid)
        string GetNodeProductName(uint32 homeid, uint8 nodeid)
        string GetNodeName(uint32 homeid, uint8 nodeid)
        string GetNodeLocation(uint32 homeid, uint8 nodeid)
        string GetNodeManufacturerId(uint32 homeid, uint8 nodeid)
        string GetNodeProductType(uint32 homeid, uint8 nodeid)
        string GetNodeProductId(uint32 homeid, uint8 nodeid)
        void SetNodeManufacturerName(uint32 homeid, uint8 nodeid, string manufacturerName)
        void SetNodeProductName(uint32 homeid, uint8 nodeid, string productName)
        void SetNodeName(uint32 homeid, uint8 nodeid, string productName)
        void SetNodeLocation(uint32 homeid, uint8 nodeid, string location)
        void SetNodeOn(uint32 homeid, uint8 nodeid)
        void SetNodeOff(uint32 homeid, uint8 nodeid)
        void SetNodeLevel(uint32 homeid, uint8 nodeid, uint8 level)
        bint IsNodeInfoReceived(uint32 homeid, uint8 nodeid)
        # bool GetNodeClassInformation(uint32 homeid, uint8 nodeid, uint8 commandClassId, string className = NULL, uint8 *classVersion = NULL)
        # // Values
        string GetValueLabel(ValueID& valueid)
        void SetValueLabel(ValueID& valueid, string value)
        string GetValueUnits(ValueID& valueid)
        void SetValueUnits(ValueID& valueid, string value)
        string GetValueHelp(ValueID& valueid)
        void SetValueHelp(ValueID& valueid, string value)
        uint32 GetValueMin(ValueID& valueid)
        uint32 GetValueMax(ValueID& valueid)
        bint IsValueReadOnly(ValueID& valueid)
        bint IsValueSet(ValueID& valueid)
        bint GetValueAsBool(ValueID& valueid, bint* o_value)
        bint GetValueAsByte(ValueID& valueid, uint8* o_value)
        bint GetValueAsFloat(ValueID& valueid, float* o_value)
        bint GetValueAsInt(ValueID& valueid, uint32* o_value)
        bint GetValueAsShort(ValueID& valueid, uint32* o_value)
        bint GetValueAsString(ValueID& valueid, string* o_value)
        bint GetValueListSelection(ValueID& valueid, string* o_value)
        bint GetValueListSelection(ValueID& valueid, uint32* o_value)
        #bint GetValueListItems(ValueID& valueid, vector<string>* o_value)
        bint SetValue(ValueID& valueid, uint8 value)
        bint SetValue(ValueID& valueid, float value)
        bint SetValue(ValueID& valueid, uint32 value)
        bint SetValue(ValueID& valueid, uint32 value)
        bint SetValue(ValueID& valueid, string value)
        bint SetValueListSelection(ValueID& valueid, string selecteditem)
        bint PressButton(ValueID& valueid)
        bint ReleaseButton(ValueID& valueid)
        uint8 GetNumSwitchPoints(ValueID& valueid)
        # // Climate Control
        bint SetSwitchPoint(ValueID& valueid, uint8 hours, uint8 minutes, uint8 setback)
        bint RemoveSwitchPoint(ValueID& valueid, uint8 hours, uint8 minutes)
        bint ClearSwitchPoints(ValueID& valueid)
        bint GetSwitchPoint(ValueID& valueid, uint8 idx, uint8* o_hours, uint8* o_minutes, uint8* o_setback)
        # // SwitchAll
        void SwitchAllOn(uint32 homeid)
        void SwitchAllOff(uint32 homeid)
        # // Configuration Parameters
        bint SetConfigParam(uint32 homeid, uint8 nodeid, uint8 param, uint32 value)
        void RequestConfigParam(uint32 homeid, uint8 nodeid, uint8 aram)
        void RequestAllConfigParams(uint32 homeid, uint8 nodeid)
        # // Groups
        uint8 GetNumGroups(uint32 homeid, uint8 nodeid)
        #uint32 GetAssociations(uint32 homeid, uint8 nodeid, uint8 groupidx, uint8** o_associations)
        uint8 GetMaxAssociations(uint32 homeid, uint8 nodeid, uint8 groupidx)
        string GetGroupLabel(uint32 homeid, uint8 nodeid, uint8 groupidx)
        void AddAssociation(uint32 homeid, uint8 nodeid, uint8 groupidx, uint8 targetnodeid)
        void RemoveAssociation(uint32 homeid, uint8 nodeid, uint8 groupidx, uint8 targetnodeid)
        bint AddWatcher(pfnOnNotification_t notification, void* context)
        bint RemoveWatcher(pfnOnNotification_t notification, void* context)
        # // Controller Commands
        void ResetController(uint32 homeid)
        void SoftReset(uint32 homeid)
        #bint BeginControllerCommand(uint32 homeid, Driver::ControllerCommand _command, Driver::pfnControllerCallback_t _callback = NULL, void* _context = NULL, bool _highPower = false, uint8 _nodeId = 0xff )
        bint CancelControllerCommand(uint32 homeid)

cdef extern from "Manager.h" namespace "OpenZWave::Manager":
    Manager* Create()
    Manager* Get()

cdef class PyOptions:
    cdef Options *options

    def create(self, char *a, char *b, char *c):
        self.options = Create(string(a), string(b), string(c))

    def lock(self):
        return self.options.Lock()

cdef class PyValueId:
    VALUE_GENRES = ('Basic', 'User', 'Config', 'System', 'Count')
    VALUE_TYPES = ('Bool','Byte','Decimal','Int','List','Schedule','Short','String','Button')

    cdef uint32 _homeid
    cdef uint8 _nodeid
    cdef uint8 _genre
    cdef uint8 _commandclassid
    cdef uint8 _instance
    cdef uint8 _index
    cdef uint8 _type
    cdef uint32 _id

    def __init__(self, homeid, nodeid, genre, commandclassid, instance, index, type, id):
        self._homeid = homeid
        self._nodeid = nodeid
        self._genre = genre
        self._commandclassid = commandclassid
        self._instance = instance
        self._index = index
        self._type = type
        self._id = id

    def getHomeId(self):
         return self._homeid

    def getNodeId(self):
        return self._nodeid

    def getGenre(self):
        return self._genre

    def getCommandClassId(self):
        return self._commandclassid

    def getInstance(self):
        return self._instance

    def getIndex(self):
        return self._index

    def getType(self):
        return self._type

    def getId(self):
        return self._id

    def __str__(self):
        return 'HomeID: [0x%0.8x] NodeID: [%d] Genre: [%s] CommandClass: [%s] Instance: [%d] Index: [%d] Type: [%s] Id: [0x%0.8x]' % \
            (self._homeid, self._nodeid, PyValueId.VALUE_GENRES[self._genre],
             PyManager.COMMAND_CLASS_DESC[self._commandclassid], self._instance, self._index,
             PyValueId.VALUE_TYPES[self._type], self._id)

cdef void do_callback(uint8 notificationtype, void* context, uint32 homeid, uint8 nodeid, uint8 groupidx, uint8 event, ValueID valueid):
    vid = PyValueId(homeid, nodeid, <int>valueid.GetGenre(), valueid.GetCommandClassId(), valueid.GetInstance(),
                    valueid.GetIndex(), <int>valueid.GetType(), valueid.GetId())
    (<object>context)(notificationtype, homeid, nodeid, vid, groupidx, event)

cdef void callback(const_notification _notification, void* _context) with gil:
    cdef Notification* notification = <Notification*>_notification
    type = notification.GetType()
    homeid = notification.GetHomeId()
    nodeid = notification.GetNodeId()
    groupIdx = notification.GetGroupIdx() if type == Type_Group else 0xff
    event = notification.GetEvent() if type == Type_NodeEvent else 0xff
    do_callback(type, _context, homeid, nodeid, groupIdx, event, notification.GetValueID())


cdef class PyManager:
    '''
The main public interface to OpenZWave.

A singleton class providing the main public interface to OpenZWave.  The
Manager class exposes all the functionality required to add Z-Wave support to
an application.  It handles the sending and receiving of Z-Wave messages as
well as the configuration of a Z-Wave network and its devices, freeing the
library user from the burden of learning the low-level details of the Z-Wave
protocol.

All Z-Wave functionality is accessed via the Manager class.  While this does
not make for the most efficient code structure, it does enable the library to
handle potentially complex and hard-to-debug issues such as multi-threading and
object lifespans behind the scenes. Application development is therefore
simplified and less prone to bugs.

There can be only one instance of the Manager class, and all applications will
start by calling Manager::Create static method to create that instance.  From
then on, a call to the Manager::Get static method will return the pointer to
the Manager object.  On application exit, Manager::Destroy should be called to
allow OpenZWave to clean up and delete any other objects it has created.

Once the Manager has been created, a call should be made to Manager::AddWatcher
to install a notification callback handler.  This handler will receive
notifications of Z-Wave network changes and updates to device values, and is an
essential element of OpenZWave.

Next, a call should be made to Manager::AddDriver for each Z-Wave controller
attached to the PC.  Each Driver will handle the sending and receiving of
messages for all the devices in its controller's Z-Wave network.  The Driver
will read any previously saved configuration and then query the Z-Wave
controller for any missing information.  Once that process is complete, a
DriverReady notification callback will be sent containing the Home ID of the
controller, which is required by most of the other Manager class methods.

[After the DriverReady notification is sent, the Driver will poll each node on
the network to update information about each node.  After all "awake" nodes
have been polled, an "AllAwakeNodesQueried" notification is sent.  This is when
a client application can expect all of the node information (both static
information, like the physical device's capabilities, session information (like
[associations and/or names] and dynamic information (like temperature or on/off
state) to be available.  Finally, after all nodes (whether listening or
sleeping) have been polled, an "AllNodesQueried" notification is sent.]
    '''
    COMMAND_CLASS_DESC = {
        0x00: 'COMMAND_CLASS_NO_OPERATION',
        0x20: 'COMMAND_CLASS_BASIC',
        0x21: 'COMMAND_CLASS_CONTROLLER_REPLICATION',
        0x22: 'COMMAND_CLASS_APPLICATION_STATUS',
        0x23: 'COMMAND_CLASS_ZIP_SERVICES',
        0x24: 'COMMAND_CLASS_ZIP_SERVER',
        0x25: 'COMMAND_CLASS_SWITCH_BINARY',
        0x26: 'COMMAND_CLASS_SWITCH_MULTILEVEL',
        0x27: 'COMMAND_CLASS_SWITCH_ALL',
        0x28: 'COMMAND_CLASS_SWITCH_TOGGLE_BINARY',
        0x29: 'COMMAND_CLASS_SWITCH_TOGGLE_MULTILEVEL',
        0x2A: 'COMMAND_CLASS_CHIMNEY_FAN',
        0x2B: 'COMMAND_CLASS_SCENE_ACTIVATION',
        0x2C: 'COMMAND_CLASS_SCENE_ACTUATOR_CONF',
        0x2D: 'COMMAND_CLASS_SCENE_CONTROLLER_CONF',
        0x2E: 'COMMAND_CLASS_ZIP_CLIENT',
        0x2F: 'COMMAND_CLASS_ZIP_ADV_SERVICES',
        0x30: 'COMMAND_CLASS_SENSOR_BINARY',
        0x31: 'COMMAND_CLASS_SENSOR_MULTILEVEL',
        0x32: 'COMMAND_CLASS_METER',
        0x33: 'COMMAND_CLASS_ZIP_ADV_SERVER',
        0x34: 'COMMAND_CLASS_ZIP_ADV_CLIENT',
        0x35: 'COMMAND_CLASS_METER_PULSE',
        0x3C: 'COMMAND_CLASS_METER_TBL_CONFIG',
        0x3D: 'COMMAND_CLASS_METER_TBL_MONITOR',
        0x3E: 'COMMAND_CLASS_METER_TBL_PUSH',
        0x38: 'COMMAND_CLASS_THERMOSTAT_HEATING',
        0x40: 'COMMAND_CLASS_THERMOSTAT_MODE',
        0x42: 'COMMAND_CLASS_THERMOSTAT_OPERATING_STATE',
        0x43: 'COMMAND_CLASS_THERMOSTAT_SETPOINT',
        0x44: 'COMMAND_CLASS_THERMOSTAT_FAN_MODE',
        0x45: 'COMMAND_CLASS_THERMOSTAT_FAN_STATE',
        0x46: 'COMMAND_CLASS_CLIMATE_CONTROL_SCHEDULE',
        0x47: 'COMMAND_CLASS_THERMOSTAT_SETBACK',
        0x4c: 'COMMAND_CLASS_DOOR_LOCK_LOGGING',
        0x4E: 'COMMAND_CLASS_SCHEDULE_ENTRY_LOCK',
        0x50: 'COMMAND_CLASS_BASIC_WINDOW_COVERING',
        0x51: 'COMMAND_CLASS_MTP_WINDOW_COVERING',
        0x60: 'COMMAND_CLASS_MULTI_CHANNEL_V2',
        0x62: 'COMMAND_CLASS_DOOR_LOCK',
        0x63: 'COMMAND_CLASS_USER_CODE',
        0x70: 'COMMAND_CLASS_CONFIGURATION',
        0x71: 'COMMAND_CLASS_ALARM',
        0x72: 'COMMAND_CLASS_MANUFACTURER_SPECIFIC',
        0x73: 'COMMAND_CLASS_POWERLEVEL',
        0x75: 'COMMAND_CLASS_PROTECTION',
        0x76: 'COMMAND_CLASS_LOCK',
        0x77: 'COMMAND_CLASS_NODE_NAMING',
        0x7A: 'COMMAND_CLASS_FIRMWARE_UPDATE_MD',
        0x7B: 'COMMAND_CLASS_GROUPING_NAME',
        0x7C: 'COMMAND_CLASS_REMOTE_ASSOCIATION_ACTIVATE',
        0x7D: 'COMMAND_CLASS_REMOTE_ASSOCIATION',
        0x80: 'COMMAND_CLASS_BATTERY',
        0x81: 'COMMAND_CLASS_CLOCK',
        0x82: 'COMMAND_CLASS_HAIL',
        0x84: 'COMMAND_CLASS_WAKE_UP',
        0x85: 'COMMAND_CLASS_ASSOCIATION',
        0x86: 'COMMAND_CLASS_VERSION',
        0x87: 'COMMAND_CLASS_INDICATOR',
        0x88: 'COMMAND_CLASS_PROPRIETARY',
        0x89: 'COMMAND_CLASS_LANGUAGE',
        0x8A: 'COMMAND_CLASS_TIME',
        0x8B: 'COMMAND_CLASS_TIME_PARAMETERS',
        0x8C: 'COMMAND_CLASS_GEOGRAPHIC_LOCATION',
        0x8D: 'COMMAND_CLASS_COMPOSITE',
        0x8E: 'COMMAND_CLASS_MULTI_INSTANCE_ASSOCIATION',
        0x8F: 'COMMAND_CLASS_MULTI_CMD',
        0x90: 'COMMAND_CLASS_ENERGY_PRODUCTION',
        0x91: 'COMMAND_CLASS_MANUFACTURER_PROPRIETARY',
        0x92: 'COMMAND_CLASS_SCREEN_MD',
        0x93: 'COMMAND_CLASS_SCREEN_ATTRIBUTES',
        0x94: 'COMMAND_CLASS_SIMPLE_AV_CONTROL',
        0x95: 'COMMAND_CLASS_AV_CONTENT_DIRECTORY_MD',
        0x96: 'COMMAND_CLASS_AV_RENDERER_STATUS',
        0x97: 'COMMAND_CLASS_AV_CONTENT_SEARCH_MD',
        0x98: 'COMMAND_CLASS_SECURITY',
        0x99: 'COMMAND_CLASS_AV_TAGGING_MD',
        0x9A: 'COMMAND_CLASS_IP_CONFIGURATION',
        0x9B: 'COMMAND_CLASS_ASSOCIATION_COMMAND_CONFIGURATION',
        0x9C: 'COMMAND_CLASS_SENSOR_ALARM',
        0x9D: 'COMMAND_CLASS_SILENCE_ALARM',
        0x9E: 'COMMAND_CLASS_SENSOR_CONFIGURATION',
        0xEF: 'COMMAND_CLASS_MARK',
        0xF0: 'COMMAND_CLASS_NON_INTEROPERABLE'
    }

    CALLBACK_DESC = ('value added','value removed','value changed','groups changed','new node','node added',
                     'node removed','node protocol info','node naming','node event','polling disabled',
                     'polling enabled','driver ready','driver reset','message complete','node queries complete',
                     'awake nodes queried','all nodes queried')

    cdef Manager *manager

    def create(self):
        '''
Creates the Manager singleton object.

The Manager provides the public interface to OpenZWave, exposing all the
functionality required to add Z-Wave support to an application. There can be
only one Manager in an OpenZWave application.  An Options object must be
created and Locked first, otherwise the call to Manager::Create will fail.
Once the Manager has been created, call AddWatcher to install a notification
callback handler, and then call the AddDriver method for each attached PC
Z-Wave controller in turn.

@param options a locked Options object containing all the application's
configurable option values.
@return a pointer to the newly created Manager object, or NULL if creation
failed.
@see options, get, addWatcher, addDriver
        '''
        self.manager = Create()
        PyEval_InitThreads()
#
# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------
# For saving the Z-Wave network configuration so that the entire network does not need to be
# polled every time the application starts.
#
    def writeConfig(self, homeid):
        '''
Saves the configuration of a PC Controller's Z-Wave network to the
application's user data folder.

This method does not normally need to be called, since OpenZWave will save the
state automatically during the shutdown process.  It is provided here only as
an aid to development. The configuration of each PC Controller's Z-Wave network
is stored in a separate file.  The filename consists of the 8 digit hexadecimal
version of the controller's Home ID, prefixed with the string 'zwcfg_'.  This
convention allows OpenZWave to find the correct configuration file for a
controller, even if it is attached to a different serial port, USB device path,
etc.

@param homeId The Home ID of the Z-Wave controller to save.
        '''
        self.manager.WriteConfig(homeid)
#
# -----------------------------------------------------------------------------
# Drivers
# -----------------------------------------------------------------------------
# Methods for adding and removing drivers and obtaining basic controller information.
#
    def addDriver(self, char *serialport):
        '''
Creates a new driver for a Z-Wave controller.

This method creates a Driver object for handling communications with a single
Z-Wave controller.  In the background, the driver first tries to read
configuration data saved during a previous run.  It then queries the controller
directly for any missing information, and a refresh of the list of nodes that
it controls.  Once this information has been received, a DriverReady
notification callback is sent, containing the Home ID of the controller.  This
Home ID is required by most of the OpenZWave Manager class methods.

@param controllerPath The string used to open the controller.  On Windows this
might be something like "\\.\\COM3", or on Linux "/dev/ttyUSB0".
@return True if a new driver was created
@see RemoveDriver
        '''
        self.manager.AddDriver(string(serialport))

    def removeDriver(self, char *serialport):
        '''
Removes the driver for a Z-Wave controller, and closes the controller.

Drivers do not need to be explicitly removed before calling Destroy - this is
handled automatically.

@param controllerPath The same string as was passed in the original call to
AddDriver.
@return True if the driver was removed, False if it could not be found.
@see AddDriver
        '''
        self.manager.RemoveDriver(string(serialport))

    def getControllerNodeId(self, homeid):
        '''
Get the node ID of the Z-Wave controller.

@param homeId The Home ID of the Z-Wave controller.
@return the node ID of the Z-Wave controller
        '''
        return self.manager.GetControllerNodeId(homeid)

    def isPrimaryController(self, homeid):
        '''
Query if the controller is a primary controller.

The primary controller is the main device used to configure and control a
Z-Wave network.  There can only be one primary controller - all other
controllers are secondary controllers.

The only difference between a primary and secondary controller is that the
primary is the only one that can be used to add or remove other devices.  For
this reason, it is usually better for the promary controller to be portable,
since most devices must be added when installed in their final location.

Calls to BeginControllerCommand will fail if the controller is not the primary.

@param homeId The Home ID of the Z-Wave controller.
@return True if it is a primary controller, False if not.
        '''
        return self.manager.IsPrimaryController(homeid)

    def isStaticUpdateController(self, homeid):
        '''
Query if the controller is a static update controller (SUC).

A Static Update Controller (SUC) is a controller that must never be moved in
normal operation and which can be used by other nodes to receive information
about network changes.

@param homeId The Home ID of the Z-Wave controller.
@return True if it is a static update controller, False if not.
        '''
        return self.manager.IsStaticUpdateController(homeid)

    def isBridgeController(self, homeid):
        '''
Query if the controller is using the bridge controller library.

A bridge controller is able to create virtual nodes that can be associated
with other controllers to enable events to be passed on.

@param homeId The Home ID of the Z-Wave controller.
@return True if it is a bridge controller, False if not.
        '''
        return self.manager.IsBridgeController(homeid)

    def getLibraryVersion(self, homeid):
        '''
Get the version of the Z-Wave API library used by a controller.

@param _homeId The Home ID of the Z-Wave controller.
@return a string containing the library version. For example, "Z-Wave 2.48".
        '''
        cdef string c_string = self.manager.GetLibraryVersion(homeid)
        return c_string.c_str()

    def getLibraryTypeName(self, homeid):
        '''
Get a string containing the Z-Wave API library type used by a controller.

The possible library types are:
    - Static Controller
    - Controller
    - Enhanced Slave
    - Slave
    - Installer
    - Routing Slave
    - Bridge Controller
    - Device Under Test

The controller should never return a slave library type.  For a more efficient
test of whether a controller is a Bridge Controller, use the IsBridgeController
method.

@param homeId The Home ID of the Z-Wave controller.
@return a string containing the library type.
@see GetLibraryVersion, IsBridgeController
        '''
        cdef string c_string = self.manager.GetLibraryTypeName(homeid)
        return c_string.c_str()
#
# -----------------------------------------------------------------------------
# Polling Z-Wave devices
# -----------------------------------------------------------------------------
# Methods for controlling the polling of Z-Wave devices.  Modern devices will
# not require polling.  Some old devices need to be polled as the only way to
# detect status changes.
#
    def getPollInterval(self):
        '''Get the time period between polls of a nodes state'''
        return self.manager.GetPollInterval()

    def setPollInterval(self, seconds):
        '''
Set the time period between polls of a nodes state.

Due to patent concerns, some devices do not report state changes automatically
to the controller.  These devices need to have their state polled at regular
intervals.  The length of the interval is the same for all devices.  To even
out the Z-Wave network traffic generated by polling, OpenZWave divides the
polling interval by the number of devices that have polling enabled, and polls
each in turn.  It is recommended that if possible, the interval should not be
set shorter than the number of polled devices in seconds (so that the network
does not have to cope with more than one poll per second).

@param seconds The length of the polling interval in seconds.
        '''
        self.manager.SetPollInterval(seconds)

#        bint EnablePoll(ValueID& valueId)
#        bint DisablePoll(ValueID& valueId)
#        bint isPolled(ValueID& valueId)
#
# -----------------------------------------------------------------------------
# Node information
# -----------------------------------------------------------------------------
# Methods for accessing information on indivdual nodes.
#
    def refreshNodeInfo(self, homeid, nodeid):
        '''
Trigger the fetching of fixed data about a node.

Causes the nodes data to be obtained from the Z-Wave network in the same way
as if it had just been added.  This method would normally be called
automatically by OpenZWave, but if you know that a node has been changed,
calling this method will force a refresh of the data held by the library.  This
can be especially useful for devices that were asleep when the application was
first run.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to query.
@return True if the request was sent successfully.
        '''
        return self.manager.RefreshNodeInfo(homeid, nodeid)

    def requestNodeState(self, homeid, nodeid):
        '''
Trigger the fetching of dynamic value data for a node.

Causes the nodes values to be requested from the Z-Wave network.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to query.
@return True if the request was sent successfully.
        '''
        self.manager.RequestNodeState(homeid, nodeid)

    def isNodeListeningDevice(self, homeid, nodeid):
        '''
Get whether the node is a listening device that does not go to sleep

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to query.
@return True if it is a listening node.
        '''
        return self.manager.IsNodeListeningDevice(homeid, nodeid)

    def isNodeRoutingDevice(self, homeid, nodeid):
        '''
Get whether the node is a routing device that passes messages to other nodes

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to query.
@return True if the node is a routing device
        '''
        return self.manager.IsNodeRoutingDevice(homeid, nodeid)

    def getNodeMaxBaudRate(self, homeid, nodeid):
        '''
Get the maximum baud rate of a nodes communications

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to query.
@return the baud rate in bits per second.
        '''
        return self.manager.GetNodeMaxBaudRate(homeid, nodeid)

    def getNodeVersion(self, homeid, nodeid):
        '''
Get the version number of a node

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to query.
@return the node version number
        '''
        return self.manager.GetNodeVersion(homeid, nodeid)

    def getNodeSecurity(self, homeid, nodeid):
        '''
Get the security byte for a node.  Bit meanings are still to be determined.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to query.
@return the node security byte
        '''
        return self.manager.GetNodeSecurity(homeid, nodeid)

    def getNodeBasic(self, homeid, nodeid):
        '''
Get the basic type of a node.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to query.
@return the node basic type.
        '''
        return self.manager.GetNodeBasic(homeid, nodeid)

    def getNodeGeneric(self, homeid, nodeid):
        '''
Get the generic type of a node.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to query.
@return the node generic type.
        '''
        return self.manager.GetNodeGeneric(homeid, nodeid)

    def getNodeSpecific(self, homeid, nodeid):
        '''
Get the specific type of a node.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to query.
@return the node specific type.
        '''
        return self.manager.GetNodeSpecific(homeid, nodeid)

    def getNodeType(self, homeid, nodeid):
        '''
Get a human-readable label describing the node

The label is taken from the Z-Wave specific, generic or basic type, depending
on which of those values are specified by the node.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to query.
@return A string containing the label text.
        '''
        cdef string c_string = self.manager.GetNodeType(homeid, nodeid)
        return c_string.c_str()

    # uint32 GetNodeNeighbors(uint32 homeid, uint8 nodeid, uint8** nodeNeighbors)

    def getNodeManufacturerName(self, homeid, nodeid):
        '''
Get the manufacturer name of a device

The manufacturer name would normally be handled by the Manufacturer Specific
commmand class, taking the manufacturer ID reported by the device and using it
to look up the name from the manufacturer_specific.xml file in the OpenZWave
config folder.  However, there are some devices that do not support the command
class, so to enable the user to manually set the name, it is stored with the
node data and accessed via this method rather than being reported via a command
class Value object.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to query.
@return A string containing the nodes manufacturer name.
@see setNodeManufacturerName, getNodeProductName, setNodeProductName
        '''
        cdef string manufacturer_string = self.manager.GetNodeManufacturerName(homeid, nodeid)
        return manufacturer_string.c_str()

    def getNodeProductName(self, homeid, nodeid):
        '''
Get the product name of a device

The product name would normally be handled by the Manufacturer Specific
commmand class, taking the product Type and ID reported by the device and using
it to look up the name from the manufacturer_specific.xml file in the OpenZWave
config folder.  However, there are some devices that do not support the command
class, so to enable the user to manually set the name, it is stored with the
node data and accessed via this method rather than being reported via a command
class Value object.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to query.
@return A string containing the nodes product name.
@see setNodeProductName, getNodeManufacturerName, setNodeManufacturerName
        '''
        cdef string productname_string = self.manager.GetNodeProductName(homeid, nodeid)
        return productname_string.c_str()

    def getNodeName(self, homeid, nodeid):
        '''
Get the name of a node

The node name is a user-editable label for the node that would normally be
handled by the Node Naming commmand class, but many devices do not support it.
So that a node can always be named, OpenZWave stores it with the node data, and
provides access through this method and SetNodeName, rather than reporting it
via a command class Value object.  The maximum length of a node name is 16
characters.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to query.
@return A string containing the node name.
@see setNodeName, getNodeLocation, setNodeLocation
        '''
        cdef string c_string = self.manager.GetNodeName(homeid, nodeid)
        return c_string.c_str()

    def getNodeLocation(self, homeid, nodeid):
        '''
Get the location of a node

The node location is a user-editable string that would normally be handled by
the Node Naming commmand class, but many devices do not support it.  So that a
node can always report its location, OpenZWave stores it with the node data,
and provides access through this method and SetNodeLocation, rather than
reporting it via a command class Value object.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to query.
@return A string containing the nodes location.
@see setNodeLocation, getNodeName, setNodeName
        '''
        cdef string c_string = self.manager.GetNodeLocation(homeid, nodeid)
        return c_string.c_str()

    def getNodeManufacturerId(self, homeid, nodeid):
        '''
Get the manufacturer ID of a device

The manufacturer ID is a four digit hex code and would normally be handled by
the Manufacturer-Specific commmand class, but not all devices support it.
Although the value reported by this method will be an empty string if the
command class is not supported and cannot be set by the user, the manufacturer
ID is still stored with the node data (rather than being reported via a command
class Value object) to retain a consistent approach with the other manufacturer
specific data.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to query.
@return A string containing the nodes manufacturer ID, or an empty string if
the manufactuer-specific command class is not supported by the device.
@see getNodeProductType, getNodeProductId, getNodeManufacturerName,
getNodeProductName
        '''
        cdef string c_string = self.manager.GetNodeManufacturerId(homeid, nodeid)
        return c_string.c_str()

    def getNodeProductType(self, homeid, nodeid):
        '''
Get the product type of a device

The product type is a four digit hex code and would normally be handled by the
Manufacturer Specific commmand class, but not all devices support it.  Although
the value reported by this method will be an empty string if the command class
is not supported and cannot be set by the user, the product type is still
stored with the node data (rather than being reported via a command class Value
object) to retain a consistent approach with the other manufacturer specific
data.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to query.
@return A string containing the nodes product type, or an empty string if the
manufactuer-specific command class is not supported by the device.
@see getNodeManufacturerId, getNodeProductId, getNodeManufacturerName,
getNodeProductName
        '''
        cdef string c_string = self.manager.GetNodeProductType(homeid, nodeid)
        return c_string.c_str()

    def getNodeProductId(self, homeid, nodeid):
        '''
Get the product ID of a device

The product ID is a four digit hex code and would normally be handled by the
Manufacturer-Specific commmand class, but not all devices support it.  Although
the value reported by this method will be an empty string if the command class
is not supported and cannot be set by the user, the product ID is still stored
with the node data (rather than being reported via a command class Value
object)  to retain a consistent approach with the other manufacturer specific
data.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to query.
@return A string containing the nodes product ID, or an empty string if the
manufactuer-specific command class is not supported by the device.
@see getNodeManufacturerId, getNodeProductType, getNodeManufacturerName,
getNodeProductName
        '''
        cdef string c_string = self.manager.GetNodeProductId(homeid, nodeid)
        return c_string.c_str()

    def setNodeManufacturerName(self, homeid, nodeid, char *manufacturerName):
        '''
Set the manufacturer name of a device

The manufacturer name would normally be handled by the Manufacturer Specific
commmand class, taking the manufacturer ID reported by the device and using it
to look up the name from the manufacturer_specific.xml file in the OpenZWave
config folder.  However, there are some devices that do not support the command
class, so to enable the user to manually set the name, it is stored with the
node data and accessed via this method rather than being reported via a command
class Value object.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to query.
@param manufacturerName A string containing the nodess manufacturer name.
@see getNodeManufacturerName, getNodeProductName, setNodeProductName
        '''
        self.manager.SetNodeManufacturerName(homeid, nodeid, string(manufacturerName))

    def setNodeProductName(self, homeid, nodeid, char *productName):
        '''
Set the product name of a device

The product name would normally be handled by the Manufacturer Specific
commmand class, taking the product Type and ID reported by the device and using
it to look up the name from the manufacturer_specific.xml file in the OpenZWave
config folder.  However, there are some devices that do not support the command
class, so to enable the user to manually set the name, it is stored with the
node data and accessed via this method rather than being reported via a command
class Value object.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to query.
@param productName A string containing the nodes product name.
@see getNodeProductName, getNodeManufacturerName, setNodeManufacturerName
        '''
        self.manager.SetNodeProductName(homeid, nodeid, string(productName))

    def setNodeName(self, homeid, nodeid, char *name):
        '''
Set the name of a node

The node name is a user-editable label for the node that would normally be
handled by the Node Naming commmand class, but many devices do not support it.
So that a node can always be named, OpenZWave stores it with the node data, and
provides access through this method and GetNodeName, rather than reporting it
via a command class Value object.  If the device does support the Node Naming
command class, the new name will be sent to the node.  The maximum length of a
node name is 16 characters.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to query.
@param nodeName A string containing the nodes name.
@see getNodeName, getNodeLocation, setNodeLocation
        '''
        self.manager.SetNodeName(homeid, nodeid, string(name))

    def setNodeLocation(self, homeid, nodeid, char *location):
        '''
Set the location of a node

The node location is a user-editable string that would normally be handled by
the Node Naming commmand class, but many devices do not support it.  So that a
node can always report its location, OpenZWave stores it with the node data,
and provides access through this method and GetNodeLocation, rather than
reporting it via a command class Value object.  If the device does support the
Node Naming command class, the new location will be sent to the node.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to query.
@param location A string containing the nodes location.
@see getNodeLocation, getNodeName, setNodeName
        '''
        self.manager.SetNodeLocation(homeid, nodeid, string(location))

    def setNodeOn(self, homeid, nodeid):
        '''
Turns a node on

This is a helper method to simplify basic control of a node.  It is the
equivalent of changing the level reported by the nodes Basic command class to
255, and will generate a ValueChanged notification from that class.  This
command will turn on the device at its last known level, if supported by the
device, otherwise it will turn it on at 100%.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to be changed.
@see setNodeOff, setNodeLevel
        '''
        self.manager.SetNodeOn(homeid, nodeid)

    def setNodeOff(self, homeid, nodeid):
        '''
Turns a node off

This is a helper method to simplify basic control of a node.  It is the
equivalent of changing the level reported by the nodes Basic command class to
zero, and will generate a ValueChanged notification from that class.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to be changed.
@see setNodeOn, setNodeLevel
        '''
        self.manager.SetNodeOff(homeid, nodeid)

    def setNodeLevel(self, homeid, nodeid, level):
        '''
Sets the basic level of a node

This is a helper method to simplify basic control of a node.  It is the
equivalent of changing the value reported by the nodes Basic command class
and will generate a ValueChanged notification from that class.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to be changed.
@param level The level to set the node.  Valid values are 0-99 and 255.  Zero
is off and 99 is fully on.  255 will turn on the device at its last known level
(if supported).

@see setNodeOn, setNodeOff
        '''
        self.manager.SetNodeLevel(homeid, nodeid, level)

    def isNodeInfoReceived(self, homeid, nodeid):
        '''
Get whether the node information has been received

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to query.
@return True if the node information has been received yet
        '''
        return self.manager.IsNodeInfoReceived(homeid, nodeid)
#
# -----------------------------------------------------------------------------
# Values
# -----------------------------------------------------------------------------
# Methods for accessing device values.  All the methods require a ValueID, which will have been provided
# in the ValueAdded Notification callback when the the value was first discovered by OpenZWave.
#
#        # bool GetNodeClassInformation(uint32 homeid, uint8 nodeid, uint8 commandClassId, string className = NULL, uint8 *classVersion = NULL)
#        string GetValueLabel(ValueID& valueid)
#        void SetValueLabel(ValueID& valueid, string value)
#        string GetValueUnits(ValueID& valueid)
#        void SetValueUnits(ValueID& valueid, string value)
#        string GetValueHelp(ValueID& valueid)
#        void SetValueHelp(ValueID& valueid, string value)
#        uint32 GetValueMin(ValueID& valueid)
#        uint32 GetValueMax(ValueID& valueid)
#        bint IsValueReadOnly(ValueID& valueid)
#        bint IsValueSet(ValueID& valueid)
#        bint GetValueAsBool(ValueID& valueid, bint* o_value)
#        bint GetValueAsByte(ValueID& valueid, uint8* o_value)
#        bint GetValueAsFloat(ValueID& valueid, float* o_value)
#        bint GetValueAsInt(ValueID& valueid, uint32* o_value)
#        bint GetValueAsShort(ValueID& valueid, uint32* o_value)
#        bint GetValueAsString(ValueID& valueid, string* o_value)
#        bint GetValueListSelection(ValueID& valueid, string* o_value)
#        bint GetValueListSelection(ValueID& valueid, uint32* o_value)
#        #bint GetValueListItems(ValueID& valueid, vector<string>* o_value)
#        bint SetValue(ValueID& valueid, uint8 value)
#        bint SetValue(ValueID& valueid, float value)
#        bint SetValue(ValueID& valueid, uint32 value)
#        bint SetValue(ValueID& valueid, uint32 value)
#        bint SetValue(ValueID& valueid, string value)
#        bint SetValueListSelection(ValueID& valueid, string selecteditem)
#        bint PressButton(ValueID& valueid)
#        bint ReleaseButton(ValueID& valueid)
#        uint8 GetNumSwitchPoints(ValueID& valueid)
#
# -----------------------------------------------------------------------------
# Climate Control Schedules
# -----------------------------------------------------------------------------
# Methods for accessing schedule values.  All the methods require a ValueID, which will have been provided
# in the ValueAdded Notification callback when the the value was first discovered by OpenZWave.
# The ValueType_Schedule is a specialized Value used to simplify access to the switch point schedule
# information held by a setback thermostat that supports the Climate Control Schedule command class.
# Each schedule contains up to nine switch points for a single day, consisting of a time in
# hours and minutes (24 hour clock) and a setback in tenths of a degree Celsius.  The setback value can
# range from -128 (-12.8C) to 120 (12.0C).  There are two special setback values - 121 is used to set
# Frost Protection mode, and 122 is used to set Energy Saving mode.
# The switch point methods only modify OpenZWave's copy of the schedule information.  Once all changes
# have been made, they are sent to the device by calling SetSchedule.
#
#        bint SetSwitchPoint(ValueID& valueid, uint8 hours, uint8 minutes, uint8 setback)
#        bint RemoveSwitchPoint(ValueID& valueid, uint8 hours, uint8 minutes)
#        bint ClearSwitchPoints(ValueID& valueid)
#        bint GetSwitchPoint(ValueID& valueid, uint8 idx, uint8* o_hours, uint8* o_minutes, uint8* o_setback)
#
# -----------------------------------------------------------------------------
# SwitchAll
# -----------------------------------------------------------------------------
# Methods for switching all devices on or off together.  The devices must support
# the SwitchAll command class.  The command is first broadcast to all nodes, and
# then followed up with individual commands to each node (because broadcasts are
# not routed, the message might not otherwise reach all the nodes).
#
    def switchAllOn(self, homeid):
        '''
Switch all devices on.  All devices that support the SwitchAll command class
will be turned on.

@param homeId The Home ID of the Z-Wave controller that manages the node.
        '''
        self.manager.SwitchAllOn(homeid)

    def switchAllOff(self, homeid):
        '''
Switch all devices off.  All devices that support the SwitchAll command class
will be turned off.

@param homeId The Home ID of the Z-Wave controller that manages the node.
        '''
        self.manager.SwitchAllOff(homeid)

# -----------------------------------------------------------------------------
# Configuration Parameters
# -----------------------------------------------------------------------------
# Methods for accessing device configuration parameters.  Configuration parameters are values
# that are managed by the Configuration command class.  The values are device-specific and are
# not reported by the devices. Information on parameters  is provided only in the device user
# manual.
#
# An ongoing task for the OpenZWave project is to create XML files describing the available
# parameters for every Z-Wave.  See the config folder in the project source code for examples.
#
    def setConfigParam(self, homeid, nodeid, param, value):
        '''
Set the value of a configurable parameter in a device.

Some devices have various parameters that can be configured to control the
device behaviour.  These are not reported by the device over the Z-Wave network
but can usually be found in the devices user manual.  This method returns
immediately, without waiting for confirmation from the device that the change
has been made.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to configure.
@param param The index of the parameter.
@param value The value to which the parameter should be set.
@return true if the a message setting the value was sent to the device.
@see requestConfigParam
        '''
        return self.manager.SetConfigParam(homeid, nodeid, param, value)

    def requestConfigParam(self, homeid, nodeid, param):
        '''
Request the value of a configurable parameter from a device.

Some devices have various parameters that can be configured to control the
device behaviour.  These are not reported by the device over the Z-Wave network
but can usually be found in the devices user manual.  This method requests
the value of a parameter from the device, and then returns immediately,
without waiting for a response.  If the parameter index is valid for this
device, and the device is awake, the value will eventually be reported via a
ValueChanged notification callback.  The ValueID reported in the callback will
have an index set the same as _param and a command class set to the same value
as returned by a call to Configuration::StaticGetCommandClassId.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to configure.
@param param The index of the parameter.
@see setConfigParam, valueID, notification
        '''
        self.manager.RequestConfigParam(homeid, nodeid, param)

    def requestAllConfigParams(self, homeid, nodeid):
        '''
Request the values of all known configurable parameters from a device.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node to configure.
@see SetConfigParam, ValueID, Notification
        '''
        self.manager.RequestAllConfigParams(homeid, nodeid)
#
# -----------------------------------------------------------------------------
# Groups (wrappers for the Node methods)
# -----------------------------------------------------------------------------
# Methods for accessing device association groups.
#
    def getNumGroups(self, homeid, nodeid):
        '''
Gets the number of association groups reported by this node

In Z-Wave, groups are numbered starting from one.  For example, if a call to
GetNumGroups returns 4, the _groupIdx value to use in calls to GetAssociations
AddAssociation and RemoveAssociation will be a number between 1 and 4.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node whose groups we are interested in.
@return The number of groups.
@see getAssociations, getMaxAssociations, addAssociation, removeAssociation
        '''
        return self.manager.GetNumGroups(homeid, nodeid)

#Gets the associations for a group.
#
#Makes a copy of the list of associated nodes in the group, and returns it in an
#array of uint8's.  The caller is responsible for freeing the array memory with
#a call to delete [].
#
#@param homeId The Home ID of the Z-Wave controller that manages the node.
#@param nodeId The ID of the node whose associations we are interested in.
#@param groupIdx One-based index of the group (because Z-Wave product manuals
#use one-based group numbering).
#@param o_associations If the number of associations returned is greater than
#zero, o_associations will be set to point to an array containing the IDs of the
#associated nodes.
#@return The number of nodes in the associations array.  If zero, the array will
#point to NULL, and does not need to be deleted.
#@see getNumGroups, addAssociation, removeAssociation, getMaxAssociations
#        #uint32 GetAssociations(uint32 homeid, uint8 nodeid, uint8 groupidx, uint8** o_associations)

    def getMaxAssociations(self, homeid, nodeid, groupidx):
        '''
Gets the maximum number of associations for a group.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node whose associations we are interested in.
@param groupIdx one-based index of the group (because Z-Wave product manuals
use one-based group numbering).
@return The maximum number of nodes that can be associated into the group.
@see getNumGroups, addAssociation, removeAssociation, getAssociations
        '''
        return self.manager.GetMaxAssociations(homeid, nodeid, groupidx)

    def getGroupLabel(self, homeid, nodeid, groupidx):
        '''
Returns a label for the particular group of a node.

This label is populated by the device specific configuration files.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node whose associations are to be changed.
@param groupIdx One-based index of the group (because Z-Wave product manuals
use one-based group numbering).
@see getNumGroups, getAssociations, getMaxAssociations, addAssociation
        '''
        cdef string c_string = self.manager.GetGroupLabel(homeid, nodeid, groupidx)
        return c_string.c_str()

    def addAssociation(self, homeid, nodeid, groupidx, targetnodeid):
        '''
Adds a node to an association group.

Due to the possibility of a device being asleep, the command is assumed to
suceeed, and the association data held in this class is updated directly.  This
will be reverted by a future Association message from the device if the Z-Wave
message actually failed to get through.  Notification callbacks will be sent in
both cases.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node whose associations are to be changed.
@param groupIdx One-based index of the group (because Z-Wave product manuals
use one-based group numbering).
@param targetNodeId Identifier for the node that will be added to the
association group.
@see getNumGroups, getAssociations, getMaxAssociations, removeAssociation
        '''
        self.manager.AddAssociation(homeid, nodeid, groupidx, targetnodeid)

    def removeAssociation(self, homeid, nodeid, groupidx, targetnodeid):
        '''
Removes a node from an association group.

Due to the possibility of a device being asleep, the command is assumed to
suceeed, and the association data held in this class is updated directly.  This
will be reverted by a future Association message from the device if the Z-Wave
message actually failed to get through.   Notification callbacks will be sent
in both cases.

@param homeId The Home ID of the Z-Wave controller that manages the node.
@param nodeId The ID of the node whose associations are to be changed.
@param groupIdx One-based index of the group (because Z-Wave product manuals
use one-based group numbering).
@param targetNodeId Identifier for the node that will be removed from the
association group.
@see getNumGroups, getAssociations, getMaxAssociations, addAssociation
        '''
        self.manager.AddAssociation(homeid, nodeid, groupidx, targetnodeid)
#
# -----------------------------------------------------------------------------
# Notifications
# -----------------------------------------------------------------------------
# For notification of changes to the Z-Wave network or device values and associations.
#
    def addWatcher(self, pythonfunc):
        '''
Add a notification watcher.

In OpenZWave, all feedback from the Z-Wave network is sent to the application
via callbacks.  This method allows the application to add a notification
callback handler, known as a "watcher" to OpenZWave.  An application needs only
add a single watcher - all notifications will be reported to it.

@param watcher pointer to a function that will be called by the notification
system.
@param context pointer to user defined data that will be passed to the watcher
function with each notification.
@return true if the watcher was successfully added.
@see removeWatcher, notification
        '''
        return self.manager.AddWatcher(callback, <void*>pythonfunc)

    def removeWatcher(self, pythonfunc):
        '''
Remove a notification watcher.

@param watcher pointer to a function that must match that passed to a previous
call to AddWatcher
@param context pointer to user defined data that must match the one passed in
that same previous call to AddWatcher.
@return true if the watcher was successfully removed.
@see AddWatcher, Notification
        '''
        return self.manager.RemoveWatcher(callback, <void*>pythonfunc)
#
# -----------------------------------------------------------------------------
# Controller commands
# ----------------------------------------------------------------------------
# Commands for Z-Wave network management using the PC Controller.
#
    def resetController(self, homeid):
        '''
Hard Reset a PC Z-Wave Controller.

Resets a controller and erases its network configuration settings.  The
controller becomes a primary controller ready to add devices to a new network.

@param homeId The Home ID of the Z-Wave controller to be reset.
@see softResetController
        '''
        self.manager.ResetController(homeid)

    def softResetController(self, homeid):
        '''
Soft Reset a PC Z-Wave Controller.

Resets a controller without erasing its network configuration settings.

@param homeId The Home ID of the Z-Wave controller to be reset.
@see resetController
        '''
        self.manager.SoftReset(homeid)

#        #bint BeginControllerCommand(uint32 homeid, Driver::ControllerCommand _command, Driver::pfnControllerCallback_t _callback = NULL, void* _context = NULL, bool _highPower = false, uint8 _nodeId = 0xff )

    def cancelControllerCommand(self, homeid):
        '''
Cancels any in-progress command running on a controller.

@param homeId The Home ID of the Z-Wave controller.
@return True if a command was running and was cancelled.
@see beginControllerCommand
        '''
        return self.manager.CancelControllerCommand(homeid)
