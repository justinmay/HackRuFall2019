import React from 'react'; 
import '../stylesheets/Tables.css';
import TableButton from './TableButton';
import {Table} from './Home';

type TablesState = {
}

type TablesProp = {
    tables: Table[],
    setCurrentTable(id: number): void,
}

class Tables extends React.Component<TablesProp,TablesState>{
    render() {
        return(
            <div className="tableContainer">
                {this.props.tables.map((table:Table) => {
                    return <TableButton 
                                name={table.key.toString()} 
                                key={table.key}
                                onClick={() => this.props.setCurrentTable(table.key)}
                            />
                })}
            </div>
        )
    }
}

export default Tables;
