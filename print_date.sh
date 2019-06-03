#! /bin/tcsh -f

set iyy = 2006
set im = 1
set idd = 1
set mday = ( 31 28 31 30 31 30 31 31 30 31 30 31 ) 
set flag = 1
while ( $iyy <= 2009 )
@  flag = $iyy % 4
  if ( $flag == 0 ) then
@    mday[2] = 29
  else
@    mday[2] = 28
  endif
  while ( $im <= 12 )
    while ( $idd <= $mday[$im] )
      
      echo "$iyy/$im/$idd"
@     idd  = $idd + 1
    end
@     idd = 1
@     im = $im + 1
  end
@     im = 1
@     iyy = $iyy + 1
end
