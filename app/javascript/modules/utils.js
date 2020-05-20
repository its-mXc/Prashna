export function split( val ) {
  return val.split( /,\s*/ );
}

export function extractLast( term ) {
  return split( term ).pop();
}
