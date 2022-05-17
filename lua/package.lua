local path = package.path
path = path .. [[;.\lua\?.lua;.\lua\lib\?.lua;.\lua\?.luac;.\lua\lib\?.luac]]

local cpath = package.cpath
cpath = cpath .. [[;.\lua\?.dll;.\lua\lib\?.dll]]

package.path = path
package.cpath = cpath