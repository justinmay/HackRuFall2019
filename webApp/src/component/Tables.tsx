import React from 'react'; 
import '../stylesheets/Tables.css';
import TableButton from './TableButton';

type TablesState = {
}

type TablesProp = {
}

class Tables extends React.Component<TablesProp,TablesState>{
    render() {
        return(
            <div className="tableContainer">
                <TableButton name="1"/>
                <TableButton name="2"/>
                <TableButton name="3"/>
            </div>
        )
    }
}

export default Tables;
