import React from 'react'; 
import '../stylesheets/TableButton.css';

type TableButtonState = {
}

type TableButtonProps = {
    name: string
}

class Tables extends React.Component<TableButtonProps,TableButtonState>{
    render() {
        return(
            <button className="button">
                Table: {this.props.name}
            </button>
        )
    }
}

export default Tables;
